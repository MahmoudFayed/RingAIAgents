

/*
Class: DashboardManager
Description: Manages customizable dashboards
*/
class DashboardManager {

    aWidgets = []
    aLayouts = []
    oCurrentLayout

    func init {
        loadAvailableWidgets()
        loadUserLayout()
    }

    func addWidget oWidget {
        aWidgets + oWidget
        updateDashboard()
    }

    func removeWidget nIndex {
        del(aWidgets, nIndex)
        updateDashboard()
    }

    func saveLayout {
        cLayout = JSON2STR(oCurrentLayout)
        write("settings/dashboard_layout.json", cLayout)
    }

    func loadLayout cName {
        if fexists("layouts/" + cName + ".json") {
            cContent = read("layouts/" + cName + ".json")
            oCurrentLayout = STR2JSON(cContent)
            applyLayout()
        }
    }

    private



    func loadAvailableWidgets {
        # Load widget definitions
        aWidgets = [
            :performance = [
                :title = "Performance Monitor",
                :type = "chart",
                :dataSource = "performance_metrics",
                :refreshRate = 5000
            ],
            :tasks = [
                :title = "Active Tasks",
                :type = "list",
                :dataSource = "task_list",
                :refreshRate = 10000
            ],
            :agents = [
                :title = "Agent Status",
                :type = "grid",
                :dataSource = "agent_status",
                :refreshRate = 3000
            ],
            :alerts = [
                :title = "System Alerts",
                :type = "feed",
                :dataSource = "alert_stream",
                :refreshRate = 1000
            ]
        ]
    }

    func loadUserLayout {
        if fexists("settings/dashboard_layout.json") {
            cContent = read("settings/dashboard_layout.json")
            oCurrentLayout = STR2JSON(cContent)
        else
            loadDefaultLayout()
        }
        applyLayout()
    }

    func loadDefaultLayout {
        oCurrentLayout = [
            :layout = "grid",
            :widgets = [
                :performance,
                :tasks,
                :agents,
                :alerts
            ],
            :positions = [
                [0, 0, 6, 4],  # Performance
                [6, 0, 12, 4], # Tasks
                [0, 4, 6, 8],  # Agents
                [6, 4, 12, 8]  # Alerts
            ]
        ]
    }

    func applyLayout {
        # Clear current dashboard
        clearDashboard()
        # Add widgets according to layout
        for i = 1 to len(oCurrentLayout[:widgets]) {
            addWidgetToPosition(
                oCurrentLayout[:widgets][i],
                oCurrentLayout[:positions][i]
            )
        }
    }

    func updateDashboard {
        # Refresh all widgets
        for widget in aWidgets {
            widget.refresh()
        }
    }

    func clearDashboard {
        # Remove all widgets from layout
        oCurrentLayout[:widgets] = []
        oCurrentLayout[:positions] = []
    }

    func setupDashboard {
        # Create dashboard layout
        oDashboardLayout = new QVBoxLayout()
        oDashboardLayout.setSpacing(15)

        # Header with gradient background
        oHeaderFrame = new QFrame()
        oHeaderFrame.setStyleSheet("
            background: qlineargradient(x1:0, y1:0, x2:1, y2:0, stop:0 #3498db, stop:1 #2980b9);
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
        ")
        oHeaderLayout = new QHBoxLayout()

        oTitleLabel = new QLabel("Dashboard")
        oTitleLabel.setStyleSheet("font-size: 28px; font-weight: bold; color: white;")
        oHeaderLayout.addWidget(oTitleLabel)

        oHeaderLayout.addStretch()

        oRefreshButton = new QPushButton("⟳ Refresh")
        oRefreshButton.setStyleSheet("
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid white;
            border-radius: 4px;
            padding: 8px 15px;
            font-size: 14px;
        ")
        oHeaderLayout.addWidget(oRefreshButton)

        oHeaderFrame.setLayout(oHeaderLayout)
        oDashboardLayout.addWidget(oHeaderFrame)

        # Stats cards
        oStatsLayout = new QHBoxLayout()
        oStatsLayout.setSpacing(15)

        # Agents card
        oAgentsCard = new QFrame()
        oAgentsCard.setFrameShape(QFrame_StyledPanel)
        oAgentsCard.setStyleSheet("
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin: 5px;
            border: 1px solid #e1e8ed;
        ")
        oAgentsCardLayout = new QVBoxLayout()
        oAgentsCardLayout.setAlignment(Qt_AlignCenter)

        oAgentsIconLabel = new QLabel("👤")
        oAgentsIconLabel.setStyleSheet("font-size: 32px; color: #3498db; margin-bottom: 10px;")
        oAgentsIconLabel.setAlignment(Qt_AlignCenter)
        oAgentsCardLayout.addWidget(oAgentsIconLabel)

        oAgentsCountLabel = new QLabel("0")
        oAgentsCountLabel.setStyleSheet("font-size: 42px; font-weight: bold; color: #2c3e50;")
        oAgentsCountLabel.setAlignment(Qt_AlignCenter)
        oAgentsCardLayout.addWidget(oAgentsCountLabel)

        oAgentsTextLabel = new QLabel("Agents")
        oAgentsTextLabel.setStyleSheet("font-size: 16px; color: #7f8c8d;")
        oAgentsTextLabel.setAlignment(Qt_AlignCenter)
        oAgentsCardLayout.addWidget(oAgentsTextLabel)

        oAgentsCard.setLayout(oAgentsCardLayout)
        oStatsLayout.addWidget(oAgentsCard)

        # Crews card
        oCrewsCard = new QFrame()
        oCrewsCard.setFrameShape(QFrame_StyledPanel)
        oCrewsCard.setStyleSheet("
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin: 5px;
            border: 1px solid #e1e8ed;
        ")
        oCrewsCardLayout = new QVBoxLayout()
        oCrewsCardLayout.setAlignment(Qt_AlignCenter)

        oCrewsIconLabel = new QLabel("👥")
        oCrewsIconLabel.setStyleSheet("font-size: 32px; color: #9b59b6; margin-bottom: 10px;")
        oCrewsIconLabel.setAlignment(Qt_AlignCenter)
        oCrewsCardLayout.addWidget(oCrewsIconLabel)

        oCrewsCountLabel = new QLabel("0")
        oCrewsCountLabel.setStyleSheet("font-size: 42px; font-weight: bold; color: #2c3e50;")
        oCrewsCountLabel.setAlignment(Qt_AlignCenter)
        oCrewsCardLayout.addWidget(oCrewsCountLabel)

        oCrewsTextLabel = new QLabel("Crews")
        oCrewsTextLabel.setStyleSheet("font-size: 16px; color: #7f8c8d;")
        oCrewsTextLabel.setAlignment(Qt_AlignCenter)
        oCrewsCardLayout.addWidget(oCrewsTextLabel)

        oCrewsCard.setLayout(oCrewsCardLayout)
        oStatsLayout.addWidget(oCrewsCard)

        # Tasks card
        oTasksCard = new QFrame()
        oTasksCard.setFrameShape(QFrame_StyledPanel)
        oTasksCard.setStyleSheet("
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin: 5px;
            border: 1px solid #e1e8ed;
        ")
        oTasksCardLayout = new QVBoxLayout()
        oTasksCardLayout.setAlignment(Qt_AlignCenter)

        oTasksIconLabel = new QLabel("📋")
        oTasksIconLabel.setStyleSheet("font-size: 32px; color: #e67e22; margin-bottom: 10px;")
        oTasksIconLabel.setAlignment(Qt_AlignCenter)
        oTasksCardLayout.addWidget(oTasksIconLabel)

        oTasksCountLabel = new QLabel("0")
        oTasksCountLabel.setStyleSheet("font-size: 42px; font-weight: bold; color: #2c3e50;")
        oTasksCountLabel.setAlignment(Qt_AlignCenter)
        oTasksCardLayout.addWidget(oTasksCountLabel)

        oTasksTextLabel = new QLabel("Tasks")
        oTasksTextLabel.setStyleSheet("font-size: 16px; color: #7f8c8d;")
        oTasksTextLabel.setAlignment(Qt_AlignCenter)
        oTasksCardLayout.addWidget(oTasksTextLabel)

        oTasksCard.setLayout(oTasksCardLayout)
        oStatsLayout.addWidget(oTasksCard)

        # Completed tasks card
        oCompletedCard = new QFrame()
        oCompletedCard.setFrameShape(QFrame_StyledPanel)
        oCompletedCard.setStyleSheet("
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin: 5px;
            border: 1px solid #e1e8ed;
        ")
        oCompletedCardLayout = new QVBoxLayout()
        oCompletedCardLayout.setAlignment(Qt_AlignCenter)

        oCompletedIconLabel = new QLabel("✅")
        oCompletedIconLabel.setStyleSheet("font-size: 32px; color: #2ecc71; margin-bottom: 10px;")
        oCompletedIconLabel.setAlignment(Qt_AlignCenter)
        oCompletedCardLayout.addWidget(oCompletedIconLabel)

        oCompletedCountLabel = new QLabel("0")
        oCompletedCountLabel.setStyleSheet("font-size: 42px; font-weight: bold; color: #2c3e50;")
        oCompletedCountLabel.setAlignment(Qt_AlignCenter)
        oCompletedCardLayout.addWidget(oCompletedCountLabel)

        oCompletedTextLabel = new QLabel("Completed")
        oCompletedTextLabel.setStyleSheet("font-size: 16px; color: #7f8c8d;")
        oCompletedTextLabel.setAlignment(Qt_AlignCenter)
        oCompletedCardLayout.addWidget(oCompletedTextLabel)

        oCompletedCard.setLayout(oCompletedCardLayout)
        oStatsLayout.addWidget(oCompletedCard)

        oDashboardLayout.addLayout(oStatsLayout)

        # Recent activity
        oActivityFrame = new QFrame()
        oActivityFrame.setFrameShape(QFrame_StyledPanel)
        oActivityFrame.setStyleSheet("
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            margin: 5px;
            border: 1px solid #e1e8ed;
        ")
        oActivityLayout = new QVBoxLayout()

        oActivityHeader = new QLabel("Recent Activity")
        oActivityHeader.setStyleSheet("font-size: 18px; font-weight: bold; color: #2c3e50; margin-bottom: 10px;")
        oActivityLayout.addWidget(oActivityHeader)

        oActivityList = new QListWidget()
        oActivityList.setStyleSheet("
            QListWidget {
                border: 1px solid #e1e8ed;
                border-radius: 4px;
                padding: 5px;
                background-color: #f8f9fa;
            }
            QListWidget::item {
                padding: 8px;
                border-bottom: 1px solid #ecf0f1;
            }
            QListWidget::item:selected {
                background-color: #3498db;
                color: white;
            }
        ")
        oActivityLayout.addWidget(oActivityList)

        oActivityFrame.setLayout(oActivityLayout)
        oDashboardLayout.addWidget(oActivityFrame)

        # Set the layout
        oDashboardWidget.setLayout(oDashboardLayout)

        # Connect signals
        oRefreshButton.setclickevent("refreshDashboard()")

        # Initial refresh
        refreshDashboard()
    }

}

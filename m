Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0DNDn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:43:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0DNDnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:43:23 -0400
Message-ID: <4BC53A33.8070202@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:44:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 4/6] gconfig: remove show_debug option
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option is a no-op, so remove it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/gconf.c     |    9 ---------
 scripts/kconfig/gconf.glade |   10 ----------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 80fe9ca..c6aa5a5 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -35,7 +35,6 @@ static gboolean show_name = TRUE;
 static gboolean show_range = TRUE;
 static gboolean show_value = TRUE;
 static gboolean show_all = FALSE;
-static gboolean show_debug = FALSE;
 static gboolean resizeable = FALSE;
 
 GtkWidget *main_wnd = NULL;
@@ -647,14 +646,6 @@ on_show_all_options1_activate(GtkMenuItem * menuitem, gpointer user_data)
 }
 
 
-void
-on_show_debug_info1_activate(GtkMenuItem * menuitem, gpointer user_data)
-{
-	show_debug = GTK_CHECK_MENU_ITEM(menuitem)->active;
-	update_tree(&rootmenu, NULL);
-}
-
-
 void on_introduction1_activate(GtkMenuItem * menuitem, gpointer user_data)
 {
 	GtkWidget *dialog;
diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
index b1c86c1..909f5a4 100644
--- a/scripts/kconfig/gconf.glade
+++ b/scripts/kconfig/gconf.glade
@@ -200,16 +200,6 @@
 		    </widget>
 		  </child>
 
-		  <child>
-		    <widget class="GtkCheckMenuItem" id="show_debug_info1">
-		      <property name="visible">True</property>
-		      <property name="tooltip" translatable="yes">Show masked options</property>
-		      <property name="label" translatable="yes">Show _debug info</property>
-		      <property name="use_underline">True</property>
-		      <property name="active">False</property>
-		      <signal name="activate" handler="on_show_debug_info1_activate"/>
-		    </widget>
-		  </child>
 		</widget>
 	      </child>
 	    </widget>
-- 
1.6.3


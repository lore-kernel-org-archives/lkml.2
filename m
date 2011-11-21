Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1KUTmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:42:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:16658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab1KUTmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:42:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78485978"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, gthelen@google.com,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Richard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 2/2] merge_config.sh: whitespace cleanup
Date: Mon, 21 Nov 2011 11:42:30 -0800
Message-Id: <03c7cecf272a4ff0de166ee9dd7b71c920981a31.1321904550.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321567131.25715.32.camel@work-vm>
References: <1321567131.25715.32.camel@work-vm>
In-Reply-To: <591b0f764fd9eb0bc7873ef775052cb038484ae7.1321904550.git.dvhart@linux.intel.com>
References: <591b0f764fd9eb0bc7873ef775052cb038484ae7.1321904550.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix whitespace usage in the clean_up routine.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 scripts/kconfig/merge_config.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index b91015d..07bb886 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -21,8 +21,8 @@
 #  See the GNU General Public License for more details.
 
 clean_up() {
-       rm -f $TMP_FILE
-       exit
+	rm -f $TMP_FILE
+	exit
 }
 trap clean_up HUP INT TERM
 
-- 
1.7.6.4


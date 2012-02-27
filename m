Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2B0EML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:12:11 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:34472 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab2B0EMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:12:09 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>, <rui.zhang@intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <salvatore.dedominicis@st.com>, <linux-kernel@vger.kernel.org>,
        <len.brown@intel.com>
Subject: [PATCH 2/2] thermal/spear_thermal: Add compilation dependency on PLAT_SPEAR
Date: Mon, 27 Feb 2012 09:41:40 +0530
Message-ID: <9ce6dc212f95e1ec8bea1d04d12b509d292b9946.1330315545.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <963d5aaac84ad075c4cfbd2babc5d264e2157502.1330315545.git.viresh.kumar@st.com>
References: <963d5aaac84ad075c4cfbd2babc5d264e2157502.1330315545.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spear_thermal is a proprietary module used for SPEAr machines only. Add compile
dependency in Kconfig for PLAT_SPEAR.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/thermal/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 2633fe0..514a691 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -22,6 +22,7 @@ config THERMAL_HWMON
 config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on THERMAL
+	depends on PLAT_SPEAR
 	help
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework
-- 
1.7.8.110.g4cb5d


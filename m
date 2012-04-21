Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2DULtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:49:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40728 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2DULs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:48:59 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 02/13] clk: Remove redundant depends on from drivers/Kconfig
Date: Sat, 21 Apr 2012 17:17:29 +0530
Message-Id: <d132e438f9ac619b95880e5afa70bdc366fced81.1335008617.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menu "Common Clock Framework" has "depends on COMMON_CLK" and so configs defined
within menu don't require these "depends on COMMON_CLK again".

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/clk/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 165e1fe..4f10a21 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -24,7 +24,6 @@ menu "Common Clock Framework"
 
 config COMMON_CLK_DISABLE_UNUSED
 	bool "Disabled unused clocks at boot"
-	depends on COMMON_CLK
 	---help---
 	  Traverses the entire clock tree and disables any clocks that are
 	  enabled in hardware but have not been enabled by any device drivers.
@@ -35,7 +34,6 @@ config COMMON_CLK_DISABLE_UNUSED
 
 config COMMON_CLK_DEBUG
 	bool "DebugFS representation of clock tree"
-	depends on COMMON_CLK
 	select DEBUG_FS
 	---help---
 	  Creates a directory hierchy in debugfs for visualizing the clk
-- 
1.7.9


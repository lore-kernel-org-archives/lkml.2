Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2C2Fs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:48:29 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:34063 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408Ab2C2FsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:48:23 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <rdunlap@xenotime.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] Documentation: pinctrl: Add missing spi0_0 grp in example
Date: Thu, 29 Mar 2012 11:03:27 +0530
Message-ID: <35e4e184dbcec04659f3c9fe648b9307ca16c9cd.1332999069.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.10.rc2.10.gb47606
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 Documentation/pinctrl.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index d97bccf..f2e27ef 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -640,7 +640,7 @@ struct foo_pmx_func {
 	const unsigned num_groups;
 };
 
-static const char * const spi0_groups[] = { "spi0_1_grp" };
+static const char * const spi0_groups[] = { "spi0_0_grp", "spi0_1_grp" };
 static const char * const i2c0_groups[] = { "i2c0_grp" };
 static const char * const mmc0_groups[] = { "mmc0_1_grp", "mmc0_2_grp",
 					"mmc0_3_grp" };
-- 
1.7.10.rc2.10.gb47606


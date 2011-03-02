Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1CBWNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:13:47 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41704 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab1CBWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:13:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77649858"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Qualcomm PM8921 MFD 5/6] MAINTAINERS: Add pmic8921, pmic8xxx subdevices maintainers
Date: Wed,  2 Mar 2011 14:13:20 -0800
Message-Id: <1299104001-5240-6-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Change-Id: I253231c9410930a221351a3d69da95e0014f4786
Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 696cb18..97107fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -905,6 +905,12 @@ F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/platform/msm/
+F:	drivers/mfd/pm8921-core.c
+F:	drivers/mfd/pm8xxx-mpp.c
+F:	include/linux/mfd/pm8921.h
+F:	include/linux/mfd/pm8xxx/
+F:	drivers/gpio/pm8xxx-gpio.c
+F:	drivers/mfd/pm8xxx-irq.c
 T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
 S:	Maintained
 
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum

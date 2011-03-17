Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1CQCYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:24:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14978 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1CQCYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:24:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6287"; a="80214597"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PM8921 MFD V3 5/6] MAINTAINERS: Add patterns for pmic 8921 files to MSM subsystem
Date: Wed, 16 Mar 2011 19:24:00 -0700
Message-Id: <1300328641-3855-6-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300328641-3855-1-git-send-email-adharmap@codeaurora.org>
References: <1300328641-3855-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 696cb18..71566a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -905,6 +905,8 @@ F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/platform/msm/
+F:	drivers/*/pm8???-*
+F:	include/linux/mfd/pm8xxx/
 T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
 S:	Maintained
 
-- 
1.7.1
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


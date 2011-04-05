Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1DEVlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:41:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45364 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1DEVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:41:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="84158245"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PM8921 MFD V5 5/6] MAINTAINERS: Add patterns for pmic 8921 files to MSM subsystem
Date: Tue,  5 Apr 2011 14:40:56 -0700
Message-Id: <1302039657-19395-6-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b4b9cd..b9db68b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -916,6 +916,8 @@ F:	drivers/mmc/host/msm_sdcc.h
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

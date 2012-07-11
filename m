Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2GKMGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:06:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33658 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2GKMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:06:24 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-3f-4ffd6c3f3138
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH V3 0/7] Initial release of Samsung S2MPS11 pmic driver
Date: Wed, 11 Jul 2012 21:06:24 +0900
Message-id: <012801cd5f5d$977580f0$c66082d0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fXZdF3pLgM6caQYKBFji49i7NkQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQV37nL/+Bg8b2C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG4RkPGAuusVdce9bL3sA4l62LkZNDQsBE4t2qXawQtpjEhXvr
	geJcHEIC0xkl7l5pYoRw5jJJ/F/7iBGkik1AQ2Ll7rdg3SICvhK/p21m6mLk4GAWCJbYeloP
	JCws4CYx+cljsKEsAqoSRw7vAGvlFTCU2Nb2mgnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3
	zCAjJQTUJR791QUxRQT0JM7dTYSoEJHY9+Id4wRGgVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iREclM+kdzCuarA4xCjAwajEw3sg66+/EGtiWXFl7iFGCQ5m
	JRHeGh+gEG9KYmVValF+fFFpTmrxIUZpDhYlcV4T76/+QgLpiSWp2ampBalFMFkmDk6pBkbG
	/f+WBgVpP5WOr8to/l4aHd69tIPreuwpvmnHr21JEdv/Rz1f0kFty6HUmGebF+r/F79XbxF4
	Zn9f0bvCgusqojObdm/NnrukR9Cw9Ou+27WOQmkRrWodU3UNJnL0RG7enacdPf3mrNcPvkS9
	WXTg3MOfc1L0rK4V/n7812uRWYfP3aLw2ZxKLMUZiYZazEXFiQBkI3+yRgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S2MPS11 is comprised of high efficient Buck converters,
various LDOs, and an RTC and tightly coupled with Multi Core Samsung 
Application Processors, which is used in a wide variety of mobile applications
such as smart phones and tablet PCs.
S2MPS11 provide 10 high efficiency buck converters and 38 LDO regulators.
Especially, Buck2 can support 7.0A current capacity for high performance
samsung application processor.
Most of S2MPS11 feature are similar to S5M series.
and Instead of using s5m prefix, Samsung decide to use s2m prefix.
So, I try to make common mfd driver for S2M and S5M series.
Most of s5m prefix is changed into sec prefix.

This patch is based on the samuel's mfd/for-next branch.

Changed since V2:
1. Apply regmap standard api in s2mps11 regulator driver
2. To avoid build breakage, squash some patches

Changes since V1:
1. Replace list_voltage with standard framework
2. Apply regmap_irq
3. Minor changes.

Thanks,
Sangbeom.


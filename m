Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab2HJCdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:33:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40526 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2HJCds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:33:48 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-99-5024730a67bb
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, cw00.choi@samsung.com,
        kyungmin.park@samsung.com, lars@metafoo.de,
        anish kumar <anish198519851985@gmail.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH resend] Extcon: renamed files to comply with the standard
 naming.
Date: Fri, 10 Aug 2012 11:33:46 +0900
Message-id: <1344566026-20813-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1344564495-20346-1-git-send-email-myungjoo.ham@samsung.com>
References: <1344564495-20346-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t9jAV2uYpUAg8trzS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGvwUzWQoec1d8e1jVwNjA1cXIySEhYCLx5eYjJghbTOLCvfVs
	XYxcHEICixgl1j7oZodwljJJvF84mxmkik1AV2LrhrssILaIgILE5t5nrCBFzAJbGCWmbTvP
	CpIQFgiW+L9jBlA3BweLgKrE9OWZICavgIfEjHlKEMsUJBbce8sGYnMKeEoc7ZsFdoQQUMnj
	Bf1MExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQI9vczqR2MKxssDjEKcDAq8fAm
	8qoECLEmlhVX5h5ilOBgVhLhTXmhHCDEm5JYWZValB9fVJqTWnyIUZqDRUmc19j7q7+QQHpi
	SWp2ampBahFMlomDU6qB0fDVhsId0uYlS1TOHWR6JlN1Z0+w1fPJxT5cql37Nro5vT8zddkH
	zsoLax7Z3OKfmLK2b0KNxrl4WRurROZAQce/rcHX/1fl3sl4fvCGxJmr6+f+3XPQetP06R4M
	n1mzTob/yTkj/eC68LawH1fyRc+aVv49rjGB4Zn7ytpb3xun/vUKYT58YZISS3FGoqEWc1Fx
	IgB2Ggru8wEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced '_' with '-' in the extcon file names, which has been bogging
since new drivers have been using the standard naming.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/Makefile                           |    4 ++--
 drivers/extcon/{extcon_class.c => extcon-class.c} |    0
 drivers/extcon/{extcon_gpio.c => extcon-gpio.c}   |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/extcon/{extcon_class.c => extcon-class.c} (100%)
 rename drivers/extcon/{extcon_gpio.c => extcon-gpio.c} (100%)

diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index bc7111e..68d6944 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -2,8 +2,8 @@
 # Makefile for external connector class (extcon) devices
 #
 
-obj-$(CONFIG_EXTCON)		+= extcon_class.o
-obj-$(CONFIG_EXTCON_GPIO)	+= extcon_gpio.o
+obj-$(CONFIG_EXTCON)		+= extcon-class.o
+obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_ADC_JACK)   += extcon-adc-jack.o
 obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
 obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon-class.c
similarity index 100%
rename from drivers/extcon/extcon_class.c
rename to drivers/extcon/extcon-class.c
diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon-gpio.c
similarity index 100%
rename from drivers/extcon/extcon_gpio.c
rename to drivers/extcon/extcon-gpio.c
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2GQKtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:49:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33117 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2GQKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:49:02 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-27-5005431da2cf
From: Vivek Gautam <gautam.vivek@samsung.com>
To: greg@kroah.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        jy0922.shim@samsung.com, jg1.han@samsung.com
Subject: [PATCH RESEND v4] USB: host: Add Device tree support for ohci-exynos &
 ehci-s5p
Date: Tue, 17 Jul 2012 16:33:25 +0530
Message-id: <1342523006-8379-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jAV1ZZ9YAg3tHuSwu75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBm3Vv1gK5jJUnHz4SK2BsbNzF2MnBwSAiYS1769gLLF
	JC7cW8/WxcjFISSwiFHi29cnLBBOO5NE+4/njCBVbAK6Ek1vd4HZIgK9jBInur1BipgFXjFK
	zPvYwwqSEBaIkuhZuh3MZhFQlbg09RQbiM0r4C6x8PE/Voh1ChKtyw6xT2DkXsDIsIpRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMj2J/PpHYwrmywOMQowMGoxMO7wJw1QIg1say4MvcQowQH
	s5II72oToBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeY++v/kIC6YklqdmpqQWpRTBZJg5OqQZG
	4Zj/7t1z7eNrQ+/MaDv8kLtNlD/wl3fLP7lDnFt7xHbMaqvf5ybEq/Ajxj65RCLLKCzsg41X
	pmhA9JSH5VurZEv0BH8uSdx6zEnpVonVamG9X1Hp/902T9uyqVjbK+7ma0e/L2JTxOSbck5z
	PRaINTrt0TJh52q9tukdCw4qv72xwlTrUbkSS3FGoqEWc1FxIgDSC46y4wEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Greg KH, and Jingoo Han in the mail thread.
Reworked third patch; other two got applied to 'usb-next' branch.

Changes from v3:
1) Change the function name from s5p_ehci_setup_gpio()
to s5p_setup_vbus_gpio(). 
2) Make s5p_setup_vbus_gpio() function to return void
instead of int.
3) Return void in case of failures.

Vivek Gautam (1):
  USB: ehci-s5p: Add vbus setup function to the s5p ehci glue layer

 drivers/usb/host/ehci-s5p.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)


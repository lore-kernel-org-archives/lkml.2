Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2GLFqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:46:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2GLFp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:45:58 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-9f-4ffe64925143
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com
Subject: [PATCH 0/2 v2] USB: host: Add Device tree support for dwc3-exynos
Date: Thu, 12 Jul 2012 11:30:01 +0530
Message-id: <1342072803-15939-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jAd1JKf/8DeYe1bK4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8Ov6PpaCPpWLWuW72BsZVzF2MnBwSAiYSnzd9ZIew
	xSQu3FvP1sXIxSEksIhR4ubMN4wQTjuTxPo1LWwgVWwCuhJNb3cxgtgiArUSU65OZQcpYhY4
	yyjRMncSSxcjB4ewgJfEpeWCIDUsAqoSN79OAtvGK+AhcfvLbqjNChKtyw6xT2DkXsDIsIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj2JvPpHcwrmqwOMQowMGoxMN7IfKfvxBrYllxZe4h
	RgkOZiURXkeQEG9KYmVValF+fFFpTmrxIUZpDhYlcV4T76/+QgLpiSWp2ampBalFMFkmDk6p
	Bsa0DPPKf8JaDUUZabWJ22cZMt9nS/1wJ+/lgqkfYouUZ65JMPEsYGrW5bY9Uyx/kV8n8c/3
	O2LmnTlCvs9DFy06qDQha1dUW/bm3TKNdcfmsb2Q+mUTlDzPv2Y1y6Q//vaM07b/+XikrP6O
	bpVMqolRoyqf+sQf96dX97wP/H3P0Pzt0t2nDimxFGckGmoxFxUnAgCIeO5s4gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
1) Added comment to explain inclusion of dma_mask through pdata.
2) Replaced gpio_request() with gpio_request_one()
3) Removed gpio_set_value()

This patchset is based and tested on 3.5 rc5.

Abhilash Kesavan (1):
  USB: dwc3-exynos: Add vbus setup function to the exynos dwc3 glue
    layer

Vivek Gautam (1):
  USB: dwc3-exynos: Add support for device tree

 drivers/usb/dwc3/dwc3-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)


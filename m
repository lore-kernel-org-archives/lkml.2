Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2GLFlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:41:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36254 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2GLFlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:41:13 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-d6-4ffe6377928f
From: Vivek Gautam <gautam.vivek@samsung.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jg1.han@samsung.com,
        jy0922.shim@samsung.com, sshtylyov@mvista.com, olofj@google.com,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: [PATCH 0/3 v2] USB: host: Add Device tree support for ohci-exynos &
 ehci-s5p
Date: Thu, 12 Jul 2012 11:25:09 +0530
Message-id: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jQd3y5H/+Bp/aRS0u75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBk7311iLpjJWtF9aCJ7A+MCli5GTg4JAROJ93+/MEPY
	YhIX7q1n62Lk4hASmM4o8WBONwuE084kcfXtNyaQKjYBXYmmt7sYQWwRgVqJKVensoMUMQt8
	Y5Ro37yKDSQhLBAusf3EO7AGFgFVie+bfrGD2LwCHhKXllxihFinING67BD7BEbuBYwMqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC/flMagfjygaLQ4wCHIxKPLwXI//5C7EmlhVX5h5i
	lOBgVhLhdQQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5zX2/uovJJCeWJKanZpakFoEk2Xi4JRq
	YJQ2Xc6nWbXbRUt4gZLogwt2yqbPLT5tuppcGZP22q3Z98NeqRk1h17texvTwmZy1ce5wi1g
	28Oewjt+s+c2OwuxC5/O7JG9yrLgpcSU5pwdmjPe8jL+/i4w2W1r9G2jPa8DVQ4zR15eUR61
	rmbZpb74d2Z3l/0ytI5Y/GYqn9vD6eIen6benqTEUpyRaKjFXFScCADs1w+O4wEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajay Kumar <ajaykumar.rs@samsung.com>

Changes from v1:
1) Added comment to explain inclusion of dma_mask through pdata.
2) Replaced gpio_request() with gpio_request_one()
3) Removed gpio_set_value()

This patchset is based and tested on 3.5 rc5.
Abhilash Kesavan (1):
  USB: ehci-s5p: Add vbus setup function to the s5p ehci glue layer

Vivek Gautam (2):
  USB: ohci-exynos: Add support for device tree
  USB: ehci-s5p: Add support for device tree

 drivers/usb/host/ehci-s5p.c    |   47 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-exynos.c |   22 ++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)


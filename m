Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1CJVuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:50:07 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46759
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751601Ab1CJVuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:50:06 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 00/21] Staging: hv: Cleanup vmbus driver 
Date: Thu, 10 Mar 2011 13:59:42 -0800
Message-Id: <1299794382-709-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes the following issues in the vmbus driver (vmbus_drv.c):

Cleanup root device management: (patches 1/21 through 10/21)
	1) Get rid of the hv_driver code from the vmbus abstraction
	2) Get rid of unnecessary call sequences and functions
	3) Cleanup the management of the root device by using the 
	   standard mechanism for grouping devices under /sys/devices

Make vmbus driver a platform pci device and cleanup irq allocation
(patches 11/21 through 12/21):
	1) Make vmbus driver a platform pci driver.
	2) Leverage the pci model for allocating irq.

General cleanup of vmbus driver (patches 13/21 though  21/21):
	1) Rename vmbus_driver_context structure and do
	   related cleanup.
	2) Get rid of forward declarations by moving code.

Regards,

K. Y
 

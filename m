Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab1COVwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:52:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48582
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758352Ab1COVwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:52:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II 
Date: Tue, 15 Mar 2011 15:02:07 -0700
Message-Id: <1300226527-26933-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes the following issues in the vmbus driver (vmbus_drv.c):

Make vmbus driver a platform pci device and cleanup
root device management and  irq allocation
(patches 1/12 through 3/12):
	1) Make vmbus driver a platform pci driver.
	2) Cleanup root device management.
	3) Leverage the pci model for allocating irq.

General cleanup of vmbus driver (patches 4/12 though  12/12):
	1) Rename vmbus_driver_context structure and do
	   related cleanup.
	2) Get rid of forward declarations by moving code.

Regards,

K. Y
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1GOR3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:29:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:60008
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753122Ab1GOR3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:17 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0117] Staging: hv: Driver cleanup
Date: Fri, 15 Jul 2011 10:47:04 -0700
Message-Id: <1310752024-27854-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanup of the hv drivers. Back in June I had sent two patch
sets to address these issues. I have addressed the comments I got from
the community on my earlier patches here:

	1) Implement code for autoloading the vmbus drivers without using PCI or DMI
	   signatures. I have implemented this based on Greg's feedback on my earlier
	   implementation.

	2) Cleanup error handling across the board and use standard Linux error codes.

	3) General cleanup

	4) Some bug fixes.

	5) Cleanup the reference counting mess for both stor and net devices.

	6) Handle all block devices using the storvsc driver. I have modified
	   the implementation here based on Christoph's feedback on my earlier
	   implementation.

	7) Accomodate some host side scsi emulation bugs.

	8) In case of scsi errors off-line the device.

This patch-set further reduces the size of Hyper-V drivers - the code is
about 10% smaller. This reduction is mainly because we have eliminated the
blkvsc driver.
	  

Regards,

K. Y 



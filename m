Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1EIVn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:43:58 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47332
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753272Ab1EIVn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:43:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 000/206] Staging: hv: Cleanup hv drivers 
Date: Mon,  9 May 2011 14:57:22 -0700
Message-Id: <1304978242-22958-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set deals with some of the architectural isues in all of
the Hyper-V drivers. Specifically:

	1) Fixes a number of locking issues in the block driver.

	2) Eliminates all the indirection through the hv_driver
	   abstraction.

	3) Simplifies the code across the board eliminating 
	   unnecessary code and data structure layering. Prior to
	   this restructuring there were about 11,000 lines of code
	   in the hv directory. After this cleanup, there are about
	   8500 lines of code.

	4) I have dealt with style and naming issues across all the drivers.

	5) All the header files have been cleaned up and consolidated:
		1) A single header file include/linux/hyperv.h. This file
		   is to be included in all the drivers that attach to the
		   vmbus.

		2) A single header file that has all the defines for building
		   the vmbus driver.
		3) Consolidate header files for each device class -
		   disk and net.


Regads,

K. Y 



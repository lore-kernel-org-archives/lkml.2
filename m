Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1BJJy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:54:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:28138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1BJJy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:54:57 -0500
Message-Id: <0d30dc$l1diqi@orsmga001.jf.intel.com>
Date: 10 Feb 2011 01:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="706136922"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 00/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel(R) Management Engine Interface (Intel(R) MEI) Driver 
==========================================================

This patch contains a new Intel driver for the Linux kernel: The Intel(R) MEI Driver.

The Intel(R) MEI driver allows applications to access
the Intel(R) Management Engine (Intel(R) ME) FW via the host
interface.


The Intel(R) MEI driver is meant to be used mainly by the
Local Manageability Service (LMS).

Note: This driver was previously called the HECI driver that was
a part of the Staging area in the Kernel and was removed.

The old MEI Driver and LMS are located on openamt.org, and are not updated
with the latest versions. A new version of LMS is under development and will be released
soon.

This set of patches is for review purposes; the driver code
for pull is in the David Woodhouse public git repository:
http://git.infradead.org/linux-2.6-mei.git

The patches is divided according to the driver files for better review process.

For more information about the MEI Driver and its usage, see:
http://software.intel.com/en-us/manageability-security/
http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/default.htm?turl=WordDocuments%2Fconnectingwiththeintelmeidriver.htm




 drivers/char/Kconfig           |   11 +
 drivers/char/Makefile          |    1 +
 drivers/char/mei/Makefile      |   23 +
 drivers/char/mei/hw.h          |  518 ++++++++++++++
 drivers/char/mei/init.c        |  837 ++++++++++++++++++++++
 drivers/char/mei/interface.c   |  478 ++++++++++++
 drivers/char/mei/interface.h   |  134 ++++
 drivers/char/mei/interrupt.c   | 1552 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/mei/iorw.c        |  822 +++++++++++++++++++++
 drivers/char/mei/main.c        | 1466 +++++++++++++++++++++++++++++++++++++
 drivers/char/mei/mei.h         |  166 +++++
 drivers/char/mei/mei_version.h |   35 +
 include/linux/mei.h            |  118 +++
 13 files changed, 6161 insertions(+), 0 deletions(-)


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


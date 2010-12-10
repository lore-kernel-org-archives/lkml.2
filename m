Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0LJUpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:45:45 -0500
Received: from mxout1.idt.com ([157.165.5.25]:39667 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab0LJUpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:45:44 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 15:45:44 EST
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 0/4] RapidIO: Misc updates
Date: Fri, 10 Dec 2010 15:38:14 -0500
Message-Id: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following four patches are follow-up to two RapidIO patches
that are in the -mm tree now.

Alexandre Bounine (4):
  RapidIO: Add definitions of Component Tag fields
  RapidIO: Add device object linking into discovery
  RapidIO: Use Component Tag for unified switch identification
  RapidIO: Add new sysfs attributes

 drivers/rapidio/rio-scan.c  |   21 ++++++++++++---------
 drivers/rapidio/rio-sysfs.c |   39 ++++++++++++++++++++++++++++++++++++++-
 drivers/rapidio/rio.c       |    2 +-
 include/linux/rio.h         |   10 ++++++++++
 4 files changed, 61 insertions(+), 11 deletions(-)

-- 
1.7.3.1


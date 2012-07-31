Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2GaSa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:30:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42728 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab2GaSa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:30:57 -0400
Date: Tue, 31 Jul 2012 12:34:36 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsi: Add maintainer for IBM virtual SCSI/FC drivers
Message-ID: <20120731173436.GA2601@linux.vnet.ibm.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <JBottomley@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073118-5930-0000-0000-00000A64B051
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS entry for the IBM Power Virtual SCSI and FC device
drivers.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb036a0..f441c46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3425,6 +3425,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
 
+IBM Power Virtual SCSI/FC Device Drivers
+M:	Robert Jennings <rcj@linux.vnet.ibm.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ibmvscsi/
+X:	drivers/scsi/ibmvscsi/ibmvstgt.c
+
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
 M:	Dave Jeffery <ipslinux@adaptec.com>
-- 
1.7.0.4


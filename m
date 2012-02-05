Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2BEAhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:37:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10950 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2BEAh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:37:29 -0500
Date: Sun, 5 Feb 2012 01:37:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-scsi@vger.kernel.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Intel SCU Linux support <intel-linux-scu@intel.com>
Subject: [PATCH] SCSI, ISCSI: Just #include "host.h" once in host.c
Message-ID: <alpine.LNX.2.00.1202050136330.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to include the header twice.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/isci/host.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1a65d65..0061cfd 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -58,7 +58,6 @@
 #include "host.h"
 #include "isci.h"
 #include "port.h"
-#include "host.h"
 #include "probe_roms.h"
 #include "remote_device.h"
 #include "request.h"
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0GCIai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:30:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:40626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab0GCIag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:30:36 -0400
Date: Sat, 3 Jul 2010 08:30:25 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: gregkh@suse.de
Cc: liodot@gmail.com, charrer@alacritech.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -staging] slicoss: README update
Message-ID: <20100703083025.GA4919@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Jul 2010 08:30:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update README to remove completed tasks
Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 drivers/staging/slicoss/README |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/slicoss/README b/drivers/staging/slicoss/README
index 70f4909..38fa160 100644
--- a/drivers/staging/slicoss/README
+++ b/drivers/staging/slicoss/README
@@ -7,14 +7,10 @@ This driver is supposed to support:
 The driver was actually tested on Oasis and Kalahari cards.
 
 TODO:
-	- move firmware loading to request_firmware()
 	- remove direct memory access of structures
 	- any remaining sparse and checkpatch.pl warnings
 
-	- use net_device_ops
 	- use dev->stats rather than adapter->stats
-	- don't cast netdev_priv it is already void
-	- use compare_ether_addr
 	- GET RID OF MACROS
 	- work on all architectures
 	   - without CONFIG_X86_64 confusion
@@ -25,10 +21,8 @@ TODO:
 	- no new SIOCDEVPRIVATE ioctl allowed
 	- don't use module_param for configuring interrupt mitigation
 	  use ethtool instead
-	- reorder code to elminate use of forward declarations
 	- don't keep private linked list of drivers.
 	- remove all the gratiutous debug infrastructure
-	- use PCI_DEVICE()
 	- do ethtool correctly using ethtool_ops
 	- NAPI?
 	- wasted overhead of extra stats
-- 
1.6.4.4


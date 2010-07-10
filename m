Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0GJUzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 16:55:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:56652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0GJUzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 16:55:40 -0400
Date: Sat, 10 Jul 2010 20:55:28 +0000
From: Denis Kirjanov <dkirjanov@hera.kernel.org>
To: gregkh@suse.de
Cc: liodot@gmail.com, charrer@alacritech.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -staging] slicoss: README update
Message-ID: <20100710205528.GA2748@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 10 Jul 2010 20:55:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update README to remove completed tasks

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 drivers/staging/slicoss/README |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/slicoss/README b/drivers/staging/slicoss/README
index 70f4909..862a87d 100644
--- a/drivers/staging/slicoss/README
+++ b/drivers/staging/slicoss/README
@@ -7,14 +7,9 @@ This driver is supposed to support:
 The driver was actually tested on Oasis and Kalahari cards.
 
 TODO:
-	- move firmware loading to request_firmware()
 	- remove direct memory access of structures
 	- any remaining sparse and checkpatch.pl warnings
 
-	- use net_device_ops
-	- use dev->stats rather than adapter->stats
-	- don't cast netdev_priv it is already void
-	- use compare_ether_addr
 	- GET RID OF MACROS
 	- work on all architectures
 	   - without CONFIG_X86_64 confusion
@@ -25,10 +20,8 @@ TODO:
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

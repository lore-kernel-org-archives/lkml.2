Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1H3FsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:48:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45503 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1H3FsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:48:17 -0400
Date: Tue, 30 Aug 2011 15:48:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasu Dev <vasu.dev@intel.com>
Subject: linux-next: manual merge of the moduleh tree with the scsi-rc-fixes
 tree
Message-Id: <20110830154814.bdef02710090d10263d1e047@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/scsi/libfc/fc_lport.c between commit 77a2b73a7805 ("[SCSI] libfc:
fix fc_eh_host_reset") from the scsi-rc-fixes tree and commit
84211284f18e ("scsi: Add module.h to drivers/scsi users who really need
it") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/libfc/fc_lport.c
index 628f347,f4e4885..0000000
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@@ -88,7 -88,7 +88,8 @@@
   */
  
  #include <linux/timer.h>
 +#include <linux/delay.h>
+ #include <linux/module.h>
  #include <linux/slab.h>
  #include <asm/unaligned.h>
  

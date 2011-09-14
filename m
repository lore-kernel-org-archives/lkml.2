Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1INFZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 01:25:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46854 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1INFZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 01:25:06 -0400
Date: Wed, 14 Sep 2011 15:25:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the moduleh tree with the s390 tree
Message-Id: <20110914152501.90490a58e3601e47a7d53c60@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/s390/char/vmur.c between commit 003184781fea ("[S390] s390: fix
mismatch in summation of I/O IRQ statistics") from the s390 tree and
commit e7a6a4ef9ffe ("s390: add missing module.h/export.h includes") from
the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.  (Or this part of the moduleh commit could be added to the
s390 tree.)
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/s390/char/vmur.c
index d291a54,c9782ff..0000000
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@@ -11,6 -11,8 +11,7 @@@
  #define KMSG_COMPONENT "vmur"
  #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
  
 -#include <linux/kernel_stat.h>
+ #include <linux/module.h>
  #include <linux/cdev.h>
  #include <linux/slab.h>
  

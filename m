Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0CSS3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:29:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42454 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0CSS3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:29:17 -0400
Date: Fri, 19 Mar 2010 14:29:15 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       ladis@linux-mips.org, tony@atomide.com
Subject: [git patch] Delete zero-length MTD file
Message-ID: <20100319182915.GA9772@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'zerolen' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git zerolen

to receive the following updates:

 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/mtd/maps/omap_nor.c

commit 17cf4442497cb2551eae1dedee638515db47c23e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Mar 19 14:25:45 2010 -0400

    Delete zero-length file drivers/mtd/maps/omap_nor.c
    
    The content was deleted in cc87edb173effdf74e680ee6d622a935ff0c1d6f,
    but the file remained as a zero-length file.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/mtd/maps/omap_nor.c b/drivers/mtd/maps/omap_nor.c
deleted file mode 100644
index e69de29..0000000

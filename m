Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0EET3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:29:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58662 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab0EET3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:29:13 -0400
Date: Wed, 5 May 2010 15:29:12 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
Subject: [git patches] Delete two zero-length files
Message-ID: <20100505192912.GA5525@havoc.gtf.org>
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
 delete mode 100644 drivers/mtd/internal.h
 delete mode 100644 drivers/mtd/mtdbdi.c

Jeff Garzik (1):
      [MTD] Remove zero-length files mtdbdi.c and internal.ho

diff --git a/drivers/mtd/internal.h b/drivers/mtd/internal.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/mtd/mtdbdi.c b/drivers/mtd/mtdbdi.c
deleted file mode 100644
index e69de29..0000000

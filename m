Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1A1IbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:31:19 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34034 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1A1IbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:31:18 -0500
Date: Fri, 28 Jan 2011 03:31:18 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cota@braap.org, martyn.welch@ge.com,
        gregkh@suse.de
Subject: [git patch] Delete zero-length file
Message-ID: <20110128083118.GA20804@havoc.gtf.org>
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
 delete mode 100644 drivers/staging/vme/bridges/Module.symvers

Jeff Garzik (1):
      Delete zero-length drivers/staging/vme/bridges/Module.symvers

diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
deleted file mode 100644
index e69de29..0000000

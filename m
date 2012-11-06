Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab2KFLKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:10:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2KFLKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:10:41 -0500
Date: Tue, 6 Nov 2012 12:10:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] floppy
Message-ID: <alpine.LNX.2.00.1211061208050.24253@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git floppy

to receive fix for race between destroying of floppy workqueue and block 
queue. Thanks!


[ This is based on your 'for-3.7/drivers' branch; it should still be 
  pushed to Linus for 3.7 still ]

Jiri Kosina (1):
      floppy: destroy floppy workqueue before cleaning up the queue

 drivers/block/floppy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs

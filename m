Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966134Ab2JZTPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:15:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966Ab2JZTPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:15:38 -0400
Date: Fri, 26 Oct 2012 21:15:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] floppy
Message-ID: <alpine.LNX.2.00.1210262112370.19184@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens

into your for-3.7/drivers branch to receive revert of patch that Sasha 
Levin reported to cause NULL pointer dereferences, and it's not necessary.

Thanks!

Jiri Kosina (1):
      Revert "genhd: Make put_disk() safe for disks that have not been registered"

 block/genhd.c          |    6 +++---
 drivers/block/floppy.c |   13 +++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
Jiri Kosina
SUSE Labs

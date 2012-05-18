Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946078Ab2ERN2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:28:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945946Ab2ERN2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:28:09 -0400
Date: Fri, 18 May 2012 15:28:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] floppy
Message-ID: <alpine.LNX.2.00.1205181524320.27407@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from 

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream

to receive 3 patches for the floppy driver. The first one fixes a number 
of races, which never exposed themselves on real floppy hardware, but are 
triggering a lot on virtualized/emulated floppy drives. The second one 
makes handling of O_EXCL on /dev/fd0 more consistent with other block 
devices (and actually fixes a userspace-visible regression). The third one 
adds myself as an unhappy maintainer, as discussed here: 
https://lkml.org/lkml/2012/5/16/370

The 'upstream' branch is based on your 'for-3.5/drivers' branch.

Thanks!

Jiri Kosina (3):
      floppy: convert to delayed work and single-thread wq
      floppy: remove floppy-specific O_EXCL handling
      floppy: take over maintainership

 MAINTAINERS            |    6 ++
 drivers/block/floppy.c |  161 +++++++++++++++++++++++-------------------------
 2 files changed, 83 insertions(+), 84 deletions(-)

-- 
Jiri Kosina
SUSE Labs

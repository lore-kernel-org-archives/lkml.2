Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2GRNng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:43:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab2GRNnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:43:32 -0400
Date: Wed, 18 Jul 2012 15:43:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] floppy
Message-ID: <alpine.LNX.2.00.1207181542320.9914@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream

to receive the patch below that should go into 3.6. Thanks.

Andi Kleen (1):
      floppy: Run floppy initialization asynchronous

 drivers/block/floppy.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2GaJqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:46:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab2GaJqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:46:13 -0400
Date: Tue, 31 Jul 2012 11:46:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
In-Reply-To: <alpine.LNX.2.00.1207181542320.9914@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1207311145160.30412@pobox.suse.cz>
References: <alpine.LNX.2.00.1207181542320.9914@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012, Jiri Kosina wrote:

> please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream
> 
> to receive the patch below that should go into 3.6. Thanks.
> 
> Andi Kleen (1):
>       floppy: Run floppy initialization asynchronous
> 
>  drivers/block/floppy.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)

Jens,

as you haven't seem to have pulled yet, I am sending an updated request 
with minor cleanup from Fengguang.

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream

to receive the floppy patches below.

Andi Kleen (1):
      floppy: Run floppy initialization asynchronous

Fengguang Wu (1):
      floppy: remove duplicated flag FD_RAW_NEED_DISK

 drivers/block/floppy.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

Thanks!

-- 
Jiri Kosina
SUSE Labs

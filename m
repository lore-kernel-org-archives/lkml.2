Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2KFLU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:20:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2KFLUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:20:25 -0500
Date: Tue, 6 Nov 2012 12:20:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
In-Reply-To: <5098F1E8.4070904@kernel.dk>
Message-ID: <alpine.LNX.2.00.1211061220090.24253@pobox.suse.cz>
References: <alpine.LNX.2.00.1211061208050.24253@pobox.suse.cz> <5098F13E.20606@kernel.dk> <alpine.LNX.2.00.1211061216570.24253@pobox.suse.cz> <5098F1E8.4070904@kernel.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Jens Axboe wrote:

> >>> Jiri Kosina (1):
> >>>       floppy: destroy floppy workqueue before cleaning up the queue
> >>>
> >>>  drivers/block/floppy.c |    5 +++--
> >>>  1 files changed, 3 insertions(+), 2 deletions(-)
> >>
> >> Can you either just send me the patch, or base it against master? After
> >> the merge window, trees should be based off for-linus (if it exists) or
> >> just Linus master.
> > 
> > OK, noted you'd like this workflow for future pull requests.
> > 
> >> For this one, I'll just grab the patch, from the email thread :-)
> > 
> > Please apply the one below then. It contains proper changelog and also the 
> > corresponding module unload fix as well. Thanks.
> 
> I did grab that one:
> 
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=baf92d83c7747f3114cd21f63930004fc03e8365

Excellent, that's the proper one. Thanks.

-- 
Jiri Kosina
SUSE Labs

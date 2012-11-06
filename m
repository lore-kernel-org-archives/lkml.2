Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab2KFLPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:15:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:44547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2KFLPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:15:48 -0500
Message-ID: <5098F13E.20606@kernel.dk>
Date: Tue, 06 Nov 2012 12:15:10 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
References: <alpine.LNX.2.00.1211061208050.24253@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1211061208050.24253@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-06 12:10, Jiri Kosina wrote:
> Jens,
> 
> please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git floppy
> 
> to receive fix for race between destroying of floppy workqueue and block 
> queue. Thanks!
> 
> 
> [ This is based on your 'for-3.7/drivers' branch; it should still be 
>   pushed to Linus for 3.7 still ]
> 
> Jiri Kosina (1):
>       floppy: destroy floppy workqueue before cleaning up the queue
> 
>  drivers/block/floppy.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

Can you either just send me the patch, or base it against master? After
the merge window, trees should be based off for-linus (if it exists) or
just Linus master.

For this one, I'll just grab the patch, from the email thread :-)

-- 
Jens Axboe


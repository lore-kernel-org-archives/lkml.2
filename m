Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2KFLSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:18:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:44575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2KFLSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:18:30 -0500
Message-ID: <5098F1E8.4070904@kernel.dk>
Date: Tue, 06 Nov 2012 12:18:00 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
References: <alpine.LNX.2.00.1211061208050.24253@pobox.suse.cz> <5098F13E.20606@kernel.dk> <alpine.LNX.2.00.1211061216570.24253@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1211061216570.24253@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-06 12:17, Jiri Kosina wrote:
> On Tue, 6 Nov 2012, Jens Axboe wrote:
> 
>>> Jiri Kosina (1):
>>>       floppy: destroy floppy workqueue before cleaning up the queue
>>>
>>>  drivers/block/floppy.c |    5 +++--
>>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> Can you either just send me the patch, or base it against master? After
>> the merge window, trees should be based off for-linus (if it exists) or
>> just Linus master.
> 
> OK, noted you'd like this workflow for future pull requests.
> 
>> For this one, I'll just grab the patch, from the email thread :-)
> 
> Please apply the one below then. It contains proper changelog and also the 
> corresponding module unload fix as well. Thanks.

I did grab that one:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=baf92d83c7747f3114cd21f63930004fc03e8365

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2GaJsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:48:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:48427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2GaJsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:48:15 -0400
Message-ID: <5017A9D9.5020800@kernel.dk>
Date: Tue, 31 Jul 2012 11:48:09 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
References: <alpine.LNX.2.00.1207181542320.9914@pobox.suse.cz> <alpine.LNX.2.00.1207311145160.30412@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1207311145160.30412@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 11:46 AM, Jiri Kosina wrote:
> On Wed, 18 Jul 2012, Jiri Kosina wrote:
> 
>> please pull from
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream
>>
>> to receive the patch below that should go into 3.6. Thanks.
>>
>> Andi Kleen (1):
>>       floppy: Run floppy initialization asynchronous
>>
>>  drivers/block/floppy.c |   21 ++++++++++++++++++++-
>>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> Jens,
> 
> as you haven't seem to have pulled yet, I am sending an updated request 
> with minor cleanup from Fengguang.
> 
> Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git upstream
> 
> to receive the floppy patches below.
> 
> Andi Kleen (1):
>       floppy: Run floppy initialization asynchronous
> 
> Fengguang Wu (1):
>       floppy: remove duplicated flag FD_RAW_NEED_DISK

I have pulled, it's in my for-3.6/drivers branch since I sent my reply.
Updated now with Wu's patch too.

-- 
Jens Axboe


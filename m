Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1AGNTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:19:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64807 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1AGNTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=VKYXolIA3TtfpR0p78fsZNVIcoc+4WtID92pNwgonF9OjU3hmJxCOUnzMWt5lMzDwf
         5X63d9QiwVb88CUhGcjA97W0fm5VlcLbNtHlYlntZEKmlmgLNlpPdHIiYSqC+oVD39pU
         1F8QvKR3bfOzvjwSLjPfuNdnStJK+jK9LbV+c=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110107231748.76170ff3.sfr@canb.auug.org.au>
References: <20110107110513.30776114.sfr@canb.auug.org.au>
	<4D26C179.7030704@kernel.dk>
	<AANLkTinyaZfsYv43046LWgu8U3kg6_79y+PTFO1RxtnY@mail.gmail.com>
	<20110107231748.76170ff3.sfr@canb.auug.org.au>
Date: Fri, 7 Jan 2011 14:19:33 +0100
Message-ID: <AANLkTimpVMLGBnP33Ro8MBtW3GJjskg0bBK717Xf-Mh_@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the block tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 1:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi All,
>
> On Fri, 7 Jan 2011 11:52:08 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> JFYI:
>> I pulled in patches from linux-2.6-block#for-next (up to commit
>> 6573422f81efa3bd71848dc584c35d4318d3de0b):
>> "Merge branch 'for-2.6.38/core' into for-next"
>> ...into linux-next (next-20110107) and now I get:
>>
>> $ grep block build_linux-next_next20110107.dileks.2.log
>> 30886 blocks
>>   CC      fs/block_dev.o
>>   CC      mm/memblock.o
>>   CC      kernel/power/block_io.o
>> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/kernel/trace/blktrace.c:999:2:
>> warning: passing argument 1 of ‘register_trace_block_bio_complete’
>> from incompatible pointer type
>> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/include/trace/events/block.h:240:1:
>> note: expected ‘void (*)(void *, struct request_queue *, struct bio *,
>> int)’ but argument is of type ‘void (*)(void *, struct request_queue
>> *, struct bio *)’
>> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/kernel/trace/blktrace.c:1038:2:
>> warning: passing argument 1 of ‘unregister_trace_block_bio_complete’
>> from incompatible pointer type
>> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/include/trace/events/block.h:240:1:
>> note: expected ‘void (*)(void *, struct request_queue *, struct bio *,
>> int)’ but argument is of type ‘void (*)(void *, struct request_queue
>> *, struct bio *)’
>
> I reported that separately today and Mathieu Desnoyers (cc'd) has said
> that he will supply a patch.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Hmm, I have pulled-in freshly from linux-2.6-block#for-next after you
published latest linux-next (next-20110107).
So, I guessed the (reported) issue is fixed, now.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=b7908c1035af7652cd613991b54dbff9c8b6bd3a

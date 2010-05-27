Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0E0Gtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:49:40 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:60923 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0E0Gti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=tnOT3PHsjgpSM3Z1tBBhhp0qVWOsvpN2/kzL75kIG5oF/ua3OfaQvpPa2OHYFAC6k6
         amTDcDYNjkfqCTUMbgZLWdhemJrhWEWoWLrDlJdEvTb/ueFSWi03qVydh6QcE1GyEPcs
         cbJmqfMttjvSO8skPhqrTZjgRVTWd9nLfEo4E=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100524175649.GV23411@kernel.dk>
References: <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 
	<AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> 
	<20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 
	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 
	<20100524175649.GV23411@kernel.dk>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Thu, 27 May 2010 08:49:16 +0200
Message-ID: <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Jens Axboe <jens.axboe@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

On Mon, May 24, 2010 at 7:56 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, May 24 2010, Michael Kerrisk wrote:
>> On Mon, May 24, 2010 at 7:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Mon, May 24 2010, Michael Kerrisk wrote:
>> >> > Right, that looks like a thinko.
>> >> >
>> >> > I'll submit a patch changing it to bytes and the agreed API and fix this
>> >> > -Eerror. Thanks for your comments and suggestions!
>> >>
>> >> Thanks. And of course you are welcome. (Please CC linux-api@vger on
>> >> this patche (and all patches that change the API/ABI.)
>> >
>> > The first change is this:
>> >
>> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b
>> >
>> > and the one dealing with the pages vs bytes API is this:
>> >
>> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29
>> >
>> > Not tested yet, will do so before sending in of course.
>>
>> Eyeballing it quickly, these changes look right.
>
> Good, thanks.
>
>> Do you have some test programs you can make available?
>
> Actually I don't, I test it by modifying fio's splice engine to set/get
> the pipe size and test the resulting transfers.

An afterthought. Do there not also need to be fixes to the /proc
interfaces. I don't think they were included in your revised patches.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/

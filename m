Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab0EXRxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:53:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57401 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0EXRxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=xbp5fXhDnby5Zd0fCRNCueSjobXuhZhPNRyXNnYx4xV/kDC5EaQG5s23egtup+cf5o
         +ZpevBz+1qvzs9+aXqHOdbCoFy37MhoHm2x+0hl4OcZPmh9ag9Nt6hCh2RMbp7Rh5M71
         uPSoh4YBRgF0L+o3WwizKNXeC5HdfYUqDQD68=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100524173551.GU23411@kernel.dk>
References: <AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> 
	<AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 
	<AANLkTin42kucqLbErGA4GlGPZEIPQV2DFkiHkEVSYiI9@mail.gmail.com> 
	<20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 
	<20100524173551.GU23411@kernel.dk>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Mon, 24 May 2010 19:52:56 +0200
Message-ID: <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com>
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

On Mon, May 24, 2010 at 7:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, May 24 2010, Michael Kerrisk wrote:
>> > Right, that looks like a thinko.
>> >
>> > I'll submit a patch changing it to bytes and the agreed API and fix this
>> > -Eerror. Thanks for your comments and suggestions!
>>
>> Thanks. And of course you are welcome. (Please CC linux-api@vger on
>> this patche (and all patches that change the API/ABI.)
>
> The first change is this:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b
>
> and the one dealing with the pages vs bytes API is this:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=b9598db3401282bb27b4aef77e3eee12015f7f29
>
> Not tested yet, will do so before sending in of course.

Eyeballing it quickly, these changes look right.

Do you have some test programs you can make available?

Thanks,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/

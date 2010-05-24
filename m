Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0EXSQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:16:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51872 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab0EXSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=U2Q2Nvnoy4plDY25bdlDrUkmbZiXU6Q7Kx2zI2bYvqHGVy/BtwbiPckmQv0giFQ24l
         DAVG9PIp1O1gWhtfVbtLyG0J+35zuTzSX4Y8GGfrklX2Ywbd75lt6esLekT5b+XB+GPY
         3hxBsYFVooMnIT1M0wcw6Ys8vj5j74CA5lCTM=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87d3wlw4mf.fsf@devron.myhome.or.jp>
References: <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> 
	<AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 
	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 
	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 
	<20100524070416.GQ23411@kernel.dk> <87bpc54u9w.fsf@devron.myhome.or.jp> 
	<20100524171522.GT23411@kernel.dk> <87d3wlw4mf.fsf@devron.myhome.or.jp>
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Mon, 24 May 2010 20:16:31 +0200
Message-ID: <AANLkTikkFusUJ3hBtv_tYFZKvluv19RsDahziDIFWkpd@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 8:12 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
>
>>> > Isn't that pretty much what I described?
>>>
>>> Yes, probably. Well, 120kb was still multiple of page size. :)
>>
>> It is, but 120KB/page_size is not (which is the power-of-2 of interest
>> here).
>
> Um... I have no interest whether rounded-up-size is power-of-2 or
> not. Because it is implementation detail.
>
> Anyway, we agreed with "in bytes" and "at least"? If so, I'm happy with
> it, and I'm sorry if I was just noise.

I thought it was good input!



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/

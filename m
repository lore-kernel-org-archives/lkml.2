Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1DFM7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:59:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42915 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1DFM7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=X+W+oiPBi4ubDU+gN6dl7/yOmtR0eN4azA4Fn1WwES2ph4xULEx9PBNmTas2ehQvdT
         a3u2AFNX69LoxB8yXa3M2rzt4p6dyvYoHk5MHT1OpCooWT73TaQTWJ9UvaNfQg8fAQun
         1U2cSMgNekYqCRnD0Drrqksibkq6TykiXwwvc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110406224202.ad201b7e.sfr@canb.auug.org.au>
References: <20110406152915.bdc2ecd3.sfr@canb.auug.org.au>
	<BANLkTikG0=JbtbAQTOj9ij7EGPKb58sUbA@mail.gmail.com>
	<20110406224202.ad201b7e.sfr@canb.auug.org.au>
Date: Wed, 6 Apr 2011 14:59:21 +0200
Message-ID: <BANLkTik4tPrnh0+J_tgyfWrPdhB-S8MC9A@mail.gmail.com>
Subject: Re: linux-next: Tree for April 6
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 2:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sedat,
>
> On Wed, 6 Apr 2011 14:19:48 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> Where is it?
>> No updates, only the US kernel-mirror in [3] has a patch.
>
> Check again now.  I can see it now on git.kernel.org (all of git
> [1234].kernel.org).
>

Yeah, now I see the updates on all URLs, but after a delay of 7 hours.
I pulled from your tree (US kernel-mirror) half an hour ago and it had
the files from yesterday (05-Apr-2011).
As linux-next is rapidly changing, a delay of 7h are inacceptable.

As a bon-bon, with todays next-20110406 I have network problems
(stalls in browser, IRC ssl-encrypted connections, etc.).
Switching back to yesterday linux-next is fine.
Lemme enjoy the sunshine here before looking at it.

>> In general:
>>
>> Whom to contact in case of this GeoIP-related(?!) slowness to
>> kernel-mirrors for people from Europe?
>
> probably ftpadmin@kernel.org. (though they are busy)
>

I will write a separate email for this.

- Sedat -

>> This problem still exists here, since end of 2010 (so called
>> "android-stuff-sync").
>> "Here" means Wild Wild South-West Germany: *.kernel.org -> *.eu.k.o
>> I am now only taking the US-URLs to clone/pull/get my stuff.
>> Can you explain what's going on?
>>
>> - Sedat -
>>
>> [1] http://www.kernel.org/pub/linux/kernel/v2.6/next/?C=M;O=D
>> [2] http://git.eu.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary
>> [3] http://www.us.kernel.org/pub/linux/kernel/v2.6/next/patch-v2.6.39-rc1-next-20110406.gz
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab0JVQD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:03:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50966 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0JVQD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=jE3ID+4YO8GlVgHFIENKxZ0uVAYvAzDHgQTgfdqZrjqWYLJmv8smxDt1Iar55EfpI6
         EBkr7Kqf4RRMpzCv8e8QevakrnOBTvIcsqtGJZ0LQt0o+FF2rjRSNDxtDU+d6bxLQqpB
         13vJKiruLpYd4OkAaA1pWTpF2JOl690ut+RsA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTikVkn2_+mhTj5uCQvKXODMUXy3cQava9Zr0L-pd@mail.gmail.com>
References: <AANLkTi=vUA-u20egbpH1Wu4ek-craz7aZUxWmobL8OhD@mail.gmail.com>
	<201010221124.32842.arnd@arndb.de>
	<AANLkTimn9u-m8eOA7dQH6kCNriebEnnbYZaP_=rnp1pv@mail.gmail.com>
	<201010221136.12073.arnd@arndb.de>
	<AANLkTikVkn2_+mhTj5uCQvKXODMUXy3cQava9Zr0L-pd@mail.gmail.com>
Date: Fri, 22 Oct 2010 18:03:24 +0200
Message-ID: <AANLkTimQSmzObOzuN3rq9CwzyCzdJ3V9WQrkqZ7fuDnY@mail.gmail.com>
Subject: Re: linux-next: next-20101022 broken with unset CONFIG_BKL
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
        Jan Harkes <jaharkes@cs.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 1:34 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Fri, Oct 22, 2010 at 11:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Friday 22 October 2010 11:30:17 Sedat Dilek wrote:
>>
>>> Wow, you answer in realtime :-), Arnd.
>>> Thanks for the explanations and I agree with you to wait for 27-rc1
>>> and then to remove BKL.
>>> Me just doing early-testing...
>>>
>>> A pointer to the patch?
>>> Thanks in advance.
>>
>> The thread is "Coda: remove BKL", You can find it on patchwork.
>>
>>        Arnd
>>
>
> Yeah, I found the triple patch-series, but #3 does not apply, here is
> a v2 for that.
>
> Please have a look at it, Thanks.
>
> [ debian/changelog ]
> ...
>  * debian/patches/for-linux-next/coda-fixes:
>    - RFC-1-3-Coda-add-spin-lock-to-protect-accesses-to-struct-coda_inode_info.patch
>      (Patch from <https://patchwork.kernel.org/patch/269131/>)
>    - RFC-2-3-Coda-push-BKL-regions-into-coda_upcall.patch
>      (Patch from <https://patchwork.kernel.org/patch/269141/>)
>    - RFC-3-3-Coda-replace-BKL-with-mutex-v2.patch (refreshed)
>      (Patch from <https://patchwork.kernel.org/patch/269151/>)
> ...
>
> Applying OK, but not compile-tested, yet.
>
> - Sedat -
>

Compilation was successful.

# modinfo coda
filename:       /lib/modules/2.6.36-next-20101022.1-686/kernel/fs/coda/coda.ko
version:        6.6
license:        GPL
alias:          char-major-67-*
description:    Coda Distributed File System VFS interface
author:         Jan Harkes, Peter J. Braam
srcversion:     AB8F3FBC43B1EBA43CEDEE5
depends:
vermagic:       2.6.36-next-20101022.1-686 SMP mod_unload modversions 686

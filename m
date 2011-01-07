Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1AGSUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:20:20 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36482 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1AGSUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=JhPSyFlwYO/nTA/FpHjHpp1idiq31/hZiLl+DPPaEuQIKGSQ5ljz/Xd9Lhx/jC1v3m
         bbGwLTsaGBgxVvLeKZ03Tt0tcN6wZMbRGF1ojf0VxRXIZ4AUWq1gQZlae8qJTh+GFVXX
         kE5pNZ/VipxdYizFnMrTRzkVQrpOgTtxGT0aQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTim_Su1XTvvpFvPqv1xpkkUA3PEVDEVpXaODjYpt@mail.gmail.com>
References: <20110107110513.30776114.sfr@canb.auug.org.au>
	<4D26C179.7030704@kernel.dk>
	<AANLkTinyaZfsYv43046LWgu8U3kg6_79y+PTFO1RxtnY@mail.gmail.com>
	<20110107231748.76170ff3.sfr@canb.auug.org.au>
	<AANLkTimpVMLGBnP33Ro8MBtW3GJjskg0bBK717Xf-Mh_@mail.gmail.com>
	<20110108012211.1e19f0f7.sfr@canb.auug.org.au>
	<4D272C54.5010406@kernel.dk>
	<AANLkTim_Su1XTvvpFvPqv1xpkkUA3PEVDEVpXaODjYpt@mail.gmail.com>
Date: Fri, 7 Jan 2011 19:20:16 +0100
Message-ID: <AANLkTimpfhc+CpxBW1xtHxuU7jN3ix_fh36jjXTxDnxM@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the block tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 7:04 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Fri, Jan 7, 2011 at 4:08 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2011-01-07 15:22, Stephen Rothwell wrote:
>>> Hi,
>>>
>>> On Fri, 7 Jan 2011 14:19:33 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>
>>>> Hmm, I have pulled-in freshly from linux-2.6-block#for-next after you
>>>> published latest linux-next (next-20110107).
>>>> So, I guessed the (reported) issue is fixed, now.
>>>
>>> No, the commit that caused the warnings was removed when I went back to
>>> using the block tree from next-20110106.  So it will come back unless
>>> fixed.
>>
>> It is fixed in linux-2.6-block#for-next as-of earlier today, so if Sedat
>> pulled from there it should be gone.
>>
>> --
>> Jens Axboe
>>
>>
>
> I guess 0002 should fix it, its not the case (patch + "big diff" attached).
>
> - Sedat -
>
[...]

Missing "blktrace: add missing probe argument to block_bio_complete" patch.

- Sedat -

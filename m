Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0GGQ1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:27:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab0GGQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tK3ieFG+UbniNnahhZMf2PHaGc2vCyWLE1w2AmXFPUxUl2SMWKRHI1+rFn1V09y38I
         AsmOdr4mMRAPoR+kijgTzPbBpg5KHl6+UBD7vDIFeehDabmGBdFP6z6iOAyP1wdZ5aio
         RybY7i0aXOJlPCP7jR4lUPwb9CpMKyaonEYdc=
MIME-Version: 1.0
In-Reply-To: <4C34A922.6090705@kernel.org>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F61AB.9030806@kernel.org>
	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
	<4C317C04.20500@kernel.org>
	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
	<4C32CE50.6010501@kernel.org>
	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
	<4C341598.6040004@kernel.org>
	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
	<4C34A1D5.1090202@kernel.org>
	<AANLkTikAENeTTHGiRO_tj3r0_rqXdFZ7KJDLYuIRpM-i@mail.gmail.com>
	<4C34A922.6090705@kernel.org>
Date: Wed, 7 Jul 2010 09:27:13 -0700
Message-ID: <AANLkTikYBjMgu4YMVzDX3w6KOmloEHoq1Dq1b4hZerfR@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 9:19 AM, Tejun Heo <tj@kernel.org> wrote:
> On 07/07/2010 06:15 PM, Mark Knecht wrote:
>> Certainly. Is there a way to reverse the previous patch?
>>
>> c2stable linux # patch -p1 --dry-run <~mark/Downloads/resume-dbg-1.patch
>> patching file drivers/ata/libata-core.c
>> Hunk #1 succeeded at 3798 (offset 86 lines).
>> Hunk #2 succeeded at 3833 with fuzz 2 (offset 94 lines).
>> Hunk #3 FAILED at 6109.
>> 1 out of 3 hunks FAILED -- saving rejects to file drivers/ata/libata-core.c.rej
>> c2stable linux #
>>
>> I assume this is failing because your patch is over the plain kernel,
>> not the one I've patched?
>
> $ patch -R -p1 < ~mark/Downloads/resume-dbg.patch
> $ patch -p1 < ~mark/Downloads/resume-dbg-1.patch
>
> --
> tejun
>
Thanks. Building the new kernel now. I'll start trying to save the
data you're looking for.

Cheers,
Mark

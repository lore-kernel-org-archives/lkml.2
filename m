Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab2DPFfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:35:07 -0400
Received: from mga05.intel.com ([192.55.52.89]:45773 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909Ab2DPFfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1204142231540.15578@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net>
	<CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com>
	<alpine.LNX.2.00.1204120030130.2137@swampdragon.chaosbits.net>
	<CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com>
	<alpine.LRH.2.02.1204141048000.29204@tundra.namei.org>
	<alpine.LNX.2.00.1204142231540.15578@swampdragon.chaosbits.net>
Date: Mon, 16 Apr 2012 08:34:45 +0300
Message-ID: <CALLzPKbgYA+A-9rro-8T4t6CHH3v12cBiyB8fQt9no5F2LVkXA@mail.gmail.com>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 11:32 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sat, 14 Apr 2012, James Morris wrote:
>
>> On Thu, 12 Apr 2012, Kasatkin, Dmitry wrote:
>>
>> > >> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> > >> >> ---
>> > >> >>  lib/mpi/mpi-bit.c |    5 +++--
>> > >> >>  1 files changed, 3 insertions(+), 2 deletions(-)
>> > >> >>
>> > >> >>  only compile tested.
>>
>> > That is of course correct.
>> >
>> > James, can you please apply this patch to security fixes?
>> >
>> >  Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> >
>> > - Dmitry
>>
>> Has this patch been tested?
>>
> Personally I don't really have a way to test it properly, so the only
> testing I've personally done is to check that it compiles.
>

It works...
In fact there are few other places in the code which take pointer
after re-sizing...

- Dmitry

> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.

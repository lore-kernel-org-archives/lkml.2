Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0JNMcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:32:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33154 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0JNMcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sNUI120LIa/RR9tnCPkxs0n67XA6gZdbyXAtZG+f52EsLd3/lkkL4H4nGEMuWfvBJl
         8STe8HicNMvu4AGjVadRU8V/MeQKgGejNLABinaFYvrR/1ZfqbxGYrgwiAM9M9C60Akh
         uJyYVJBDDUD97Wszx9daWYmCEktR2l6ZRsNaI=
MIME-Version: 1.0
In-Reply-To: <20101014160217N.fujita.tomonori@lab.ntt.co.jp>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<87sk0a1sq0.fsf@basil.nowhere.org>
	<20101014160217N.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 14 Oct 2010 15:09:13 +0300
Message-ID: <AANLkTin-8mjL_B8g9cPoviQU0FUaEyb_v5_Fm4kbSweA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: Felipe Contreras <felipe.contreras@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:07 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 13 Oct 2010 09:01:43 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
>
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>> >
>> > What this wants to do:
>> >   allocates a contiguous chunk of pages larger than MAX_ORDER.
>> >   for device drivers (camera? etc..)
>>
>> I think to really move forward you need a concrete use case
>> actually implemented in tree.
>
> As already pointed out, some embeded drivers need physcailly
> contignous memory. Currenlty, they use hacky tricks (e.g. playing with
> the boot memory allocators). There are several proposals for this like
> adding a new kernel memory allocator (from samsung).
>
> It's ideal if the memory allocator can handle this, I think.

Not only contiguous, but sometimes also coherent.

-- 
Felipe Contreras

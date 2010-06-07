Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0FGFUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:20:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62019 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0FGFUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KYqUZfCOWyJuzrbLX6cqDkdrq2W2tuE8rSs3haPjBhVl4F4yTbveIuOPVv/Bovt98d
         p76wPBX2Be/3wPDz5I8kBXAIG2klvFLVMFTbiZT9psYsvUdB9vo6bdi1txdO7Ue9XY6S
         E+VsQWVgC8v7s593F5pEiqHnHqTziD3zN8Cjs=
MIME-Version: 1.0
In-Reply-To: <AANLkTillFhDzhz06IXArHKbZCy9zBI5Isl4c2DiROXlz@mail.gmail.com>
References: <AANLkTilb4QNYznFeJVfMmvPAlBY-B02EY0i0d7NK9X7O@mail.gmail.com>
	<tnxvd9zcbr9.fsf@e102109-lin.cambridge.arm.com>
	<AANLkTillFhDzhz06IXArHKbZCy9zBI5Isl4c2DiROXlz@mail.gmail.com>
Date: Mon, 7 Jun 2010 13:20:42 +0800
Message-ID: <AANLkTikXdy6GOQ2EzDt-yrcJ_jMIPvLsH3neWBozpVCK@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 lots of suspected kmemleak
From: Dave Young <hidave.darkstar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 9:55 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Fri, Jun 4, 2010 at 6:50 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> Dave Young <hidave.darkstar@gmail.com> wrote:
>>> With mmotm 2010-06-03-16-36, I gots tuns of kmemleaks
>>
>> Do you have CONFIG_NO_BOOTMEM enabled? I posted a patch for this but
>> hasn't been reviewed yet (I'll probably need to repost, so if it fixes
>> the problem for you a Tested-by would be nice):
>>
>> http://lkml.org/lkml/2010/5/4/175
>
>
> I'd like to test, but I can not access the test pc during weekend. So
> I will test it next monday.

Bad news, the patch does not fix this issue.

>
> For CONFIG_NO_BOOTMEM, I don't remember. I guess set as 'y'

Confirmed, CONFIG_NO_BOOTMEM=y
>>
>> Thanks.
>>
>> --
>> Catalin
>>
>
> --
> Regards
> dave
>



-- 
Regards
dave

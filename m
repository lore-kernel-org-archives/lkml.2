Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0FKIIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:08:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60831 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab0FKIIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lGj6uuZ4u38AjFLnPZN874Pp2cTwZo9nPdfDb8Q7fc+FT1HdUo64uzRvOHOzQliChs
         FO3MCZec9z8PF+VJHS0LKOzSQITGjvtYljZz3MmVQAksD0CtwpxFhKJB+YkOuiZasadw
         fIEDx5VE2RjAknuFSka+jhgwNxM1UElOo/HqU=
MIME-Version: 1.0
In-Reply-To: <1276168866.24535.25.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTin1OS3LohKBvWyS81BoAk15Y-riCiEdcevSA7ye@mail.gmail.com>
	<1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
	<AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
	<AANLkTik-cwrabXH_bQRPFtTo3C9r30B83jMf4IwJKCms@mail.gmail.com>
	<20100609211617.3e7e41bd@annuminas.surriel.com>
	<AANLkTin9UTy3qSWJ8u3b1hwhnsX5NHCZNzkFbH9_-vIZ@mail.gmail.com>
	<1276168866.24535.25.camel@e102109-lin.cambridge.arm.com>
Date: Fri, 11 Jun 2010 16:08:08 +0800
Message-ID: <AANLkTikl2Lp6dhDIN2NpyZHJne_vhOYJrwwBGebkslCf@mail.gmail.com>
Subject: Re: [PATCH -mm] only drop root anon_vma if not self
From: Dave Young <hidave.darkstar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 7:21 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Dave,
>
> On Thu, 2010-06-10 at 02:30 +0100, Dave Young wrote:
>> On Thu, Jun 10, 2010 at 9:16 AM, Rik van Riel <riel@redhat.com> wrote:
>> > On Wed, 9 Jun 2010 17:19:02 +0800
>> > Dave Young <hidave.darkstar@gmail.com> wrote:
>> >
>> >> > Manually bisected mm patches, the memleak caused by following patch:
>> >> >
>> >> > mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
>> >>
>> >>
>> >> So I guess the refcount break, either drop-without-get or over-drop
>> >
>> > I'm guessing I did not run the kernel with enough debug options enabled
>> > when I tested my patches...
>> >
>> > Dave & Catalin, thank you for tracking this down.
>> >
>> > Dave, does the below patch fix your issue?
>>
>> Yes, it fixed the issue. Thanks.
>
> Thanks for investigating this issue.
>
> BTW, without my kmemleak nobootmem patch (and CONFIG_NOBOOTMEM enabled),
> do you get other leaks (false positives).

Hi, catalin

I didn't see difference before/after apply your patch, how to test
specific to bootmem?

> If my patch fixes the
> nobootmem problem, can I add a Tested-by: Dave Young?
>
> Thanks.
>
> --
> Catalin
>
>



-- 
Regards
dave

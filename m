Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0FLBuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:50:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36392 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FLBuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Grk37e22rKICQqJPmPmN/QD1t+shnM6ZehR3Ib1Wymi2tJIhqo4T7VoDCQRvrM+Faj
         yVwzAG+FayLWdii8EkkgkVGqUDUteyTjLDnpYd8mtdlgxbyykrOwH5I3FX/vEW6hTKG8
         R3v0K2AIUfX00UaEwD7CqW7p4xVcUH9BHeJEc=
MIME-Version: 1.0
In-Reply-To: <1276250772.12258.57.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTiktcGrj-tcMspzR3sXplKk-PFB7M4q7rb-WiwYP@mail.gmail.com>
	<1276250772.12258.57.camel@e102109-lin.cambridge.arm.com>
Date: Sat, 12 Jun 2010 09:50:34 +0800
Message-ID: <AANLkTikc3NAxOXANiFLJ9SqhdHs_11QsnX-JlwF95Alz@mail.gmail.com>
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

On Fri, Jun 11, 2010 at 6:06 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, 2010-06-11 at 10:48 +0100, Dave Young wrote:
>> I got an oops when shutdown kvm guest with rik's patch applied, but
>> without your bootmem patch, is it kmemleak problem?
>
> It could be, though I've never got it before.
>
> Can you run this on your vmlinux file?
>
> addr2line -i -f -e vmlinux c10c5c88

The vmlinux is lost, I rebuid it with same config

bash-3.1$ addr2line -i -f -e vmlinux 0xc10c5c88
put_object
/home/dave/mm/linux-2.6.35-rc1/mm/kmemleak.c:45

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

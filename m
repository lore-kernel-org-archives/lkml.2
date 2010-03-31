Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0CaMKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:10:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41155 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab0CaMKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pGD2jHTGuVrX5mTuxqBNS3nSUC1iX/Vet7Aq0c1/YJWi8fldvO+n9J3bd+B1W4WWZI
         uIljNgHhDXjoyqRfeLic1t0U7yRuUpwCR0tjN9m31i8/G68gHQbCNC41lVR9k3HfHP31
         w0xb/Al3RMRjkFo9hyIzKGe5LzwnYSZL5yX0M=
MIME-Version: 1.0
In-Reply-To: <tnx7hosy9t2.fsf@e102109-lin.cambridge.arm.com>
References: <n2m72cf309c1003310300k26b9aacbob7b49ff2f43f949d@mail.gmail.com> 
	<tnx7hosy9t2.fsf@e102109-lin.cambridge.arm.com>
From: Sachin Pandhare <sachinpandhare@gmail.com>
Date: Wed, 31 Mar 2010 17:40:25 +0530
Message-ID: <y2t72cf309c1003310510o87c33ebew5278758fe76556a9@mail.gmail.com>
Subject: Re: kmemleak_scan_area
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 5:36 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Sachin Pandhare <sachinpandhare@gmail.com> wrote:
>> In kmemleak.c file "kmemleak_scan_area" is appearing as a structure as
>> well as a function.
>> e.g.:
>> - struct kmemleak_scan_area {
>> - void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
>>
>> Do you think it is a good to have it like that?
>
> Does it cause any problems? I think C has different namespaces for types
> and functions, so they should not collide. I agree that from a
> readability perspective, it would be better if they are named
> differently (like kmemleak_scan_area_node :)).

It has not caused any problem.
Thanks,

>
> --
> Catalin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0JXQxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:53:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42208 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab0JXQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=CiRW9mYQu9L34INc8ip9/iN0cq3lsQlT6Ice/jhiPmmc93OAumX7ExFk/oYvV4chvT
         VM4LGyXsuwsx51J9kKn+9j5IJZju/wrc9K6w42E583+ym7tbQ4G3R3Ky8O/QCQqEknnR
         2Z6wxyaoE9Hseqm/VrPDYoGBbx7pnMPlgfVfM=
MIME-Version: 1.0
In-Reply-To: <4CC45F56.7010305@redhat.com>
References: <AANLkTinbeAn4ObFSb4f4znjYHGNKTMnfV7eQja+cnsLe@mail.gmail.com>
 <20100911065725.GA6279@fancy-poultry.org> <AANLkTikTq=GTy-XPD6ye6kStASNL4Pa07wHhH_ABmpm1@mail.gmail.com>
 <AANLkTim7RvpOcBajyqCkrBP8EW-FwNysvwuF5MaDJiFV@mail.gmail.com>
 <AANLkTi=PCd1=w-mkc=Sj4EEda=PnTv0JGyV1Ysxq4ej4@mail.gmail.com>
 <AANLkTikLSFFpbgX+rBR5banBygmB6rRvzMBYKfPcFPuJ@mail.gmail.com>
 <4C8C9834.8060201@redhat.com> <AANLkTi=8jJMz3f0VGwg+6P+BJEfxj6i-jBkGmqx8hCVg@mail.gmail.com>
 <AANLkTinohRReVsYoetEjqAp-XrL9C2jxGgXLVnLafSUM@mail.gmail.com>
 <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com> <4CC45F56.7010305@redhat.com>
From: dave b <db.pub.mail@gmail.com>
Date: Mon, 25 Oct 2010 03:52:41 +1100
Message-ID: <AANLkTi=Hw-iU98rTjyDFAPSqqrWvzhOnE_0UBV-tMeie@mail.gmail.com>
Subject: Re: Fwd: [dm-crypt] [BUG] bad performance and system stalls when
 using dm-crypt
To: Milan Broz <mbroz@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2010 03:31, Milan Broz <mbroz@redhat.com> wrote:
> On 10/24/2010 05:32 PM, dave b wrote:
>> I am forwarding this to the linux kernel mailing list to see if anyone
>> is actually interested with this bug or not. I suspect that the patch
>> to allow DM-CRYPT to use multiple cpus(Scale to multiple CPUs) will
>> remove most of the problem but *not* all of it. As I previously was
>> triggering the bug on a single core system.
>
> Hi,
> sorry for not updating the bug. We know about this.
>
> Fix was expected to be based on top of the Andi's dm-crypt per-cpu
> patch but unfortunately I found serious problems there
> (see this thread http://lkml.org/lkml/2010/10/20/215 )
>
> So there are now several known situations when dm-crypt doesn't
> perform as expected (another problem just appeared when using CFQ,
> (because dm(-crypt) lost the issuing process reference)
> see http://lkml.org/lkml/2010/10/24/59).

Thank for you replying  ^ ^
I was aware with the problems and I am following Andi's dm-crypt
per-cpu patch (I haven't applied or tested it). However, I didn't know
about http://lkml.org/lkml/2010/10/24/59 -->
So this may well be the root of the problem!
Also, won't http://lkml.org/lkml/2010/10/24/59  need to be altered
(again) to work with Andi's patch ?


--
There's small choice in rotten apples.		-- William Shakespeare, "The
Taming of the Shrew"

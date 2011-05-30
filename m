Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1E3Kkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:40:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58453 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1E3Kku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jPENVwBDbmOfIcuPzwRegKCON3ORMpEUrR3aizdYJ0cCwL/1LdosQ2icz+FcVIsgRQ
         y82jMNERwL/2vPfh1APVuLUIh3j+v73hiuopG5wa0j50YUwOC+0myNP39Kc7kDaMgXdh
         /GLffrUJKt5ceWlOMNBXOwk9a6ZOc4MpJWhBo=
MIME-Version: 1.0
In-Reply-To: <1306747629.2029.397.camel@i7.infradead.org>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530091536.GA2827@elte.hu>
	<1306747629.2029.397.camel@i7.infradead.org>
Date: Mon, 30 May 2011 13:40:49 +0300
Message-ID: <BANLkTik78bVy-rde9YLOj6wp6rDfj_GKmw@mail.gmail.com>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:27 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2011-05-30 at 11:15 +0200, Ingo Molnar wrote:
>>
>> > I believe that this 'filtered randconfig' behaviour is now fairly much
>> > the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'.
>>
>> I use "make ARCH=i386 defconfig" and "make ARCH=x86_64 defconfig" all
>> the time.
>
> Good point. But shouldn't "make i386_defconfig" and "make
> x86_64_defconfig" do that?

No, because there is no point.

make ARCH=i386   allnoconfig
make ARCH=x86_64 allnoconfig
make ARCH=i386   defconfig
make ARCH=x86_64 defconfig
make ARCH=i386   allmodconfig
make ARCH=x86_64 allmodconfig

are OK and are used this way and are consistent with other archs.

Unification to death is not needed.

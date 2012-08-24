Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2HXM7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:59:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58320 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2HXM7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <1345812057.28613.20.camel@thorin>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208231814.21168.tweek@tweek.dk>
	<CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
	<201208231951.28606.linux@rainbow-software.org>
	<CAJ7jCmnwXNXmoxT6sdOc-8znsUnnW+Rq8ioJ_8B8KnT0K2uc=A@mail.gmail.com>
	<1345812057.28613.20.camel@thorin>
Date: Fri, 24 Aug 2012 14:59:29 +0200
Message-ID: <CAJ7jCm=bZoHS0-qiiJnUjZb3gP6ibo1xbLsmaUJr2rL4pAU8Eg@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Ondrej Zary <linux@rainbow-software.org>,
        Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/12, Bernd Petrovitsch <bernd@petrovitsch.priv.at> wrote:
> What do you mean with "Linux"? The Linux kernel as such? Some (and
> which) distributions?
Linux kernel first, distributions and software will follow
>
> And you obviously never thought about embedded devices.
> Servers, laptops, notebooks and desktop computers are not the whole
> computing world - and from the pure numbers not even the majority BTW.
I don't request dropping support for ARM and other platforms which are
still in production

> Please proof that it will be developed "faster" (whatever that means
> to you). Thank you.
Developers won't have to maintain e.g. x86-32 assembler code and can
work on x32 and x86-64 instead.

> So you want the Linux kernel people to drop support for some
> architecture in the hope others follow (because you will consequently
> send mails there with "the Linux kernel dropped the support, you should
> too" hoping that some other software will be developed
> "faster" (whatever that means to you)?
exactly

> *If* you really miss something in some other parts (compilers,
> virtualization, ...) or they developing to slow *for you*, help them and
> send patches there but do not try to lure others into fighting your
> cause.
I don't have knowledge about compilers and virtualization. I work on
general GUI applications (Java and C++) and web pages.

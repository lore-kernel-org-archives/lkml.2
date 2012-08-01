Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2HAJ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:28:18 -0400
Received: from seven.medozas.de ([5.9.24.206]:41422 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2HAJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:28:17 -0400
Date: Wed, 1 Aug 2012 11:28:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
cc: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
In-Reply-To: <20120801074335.GG29673@avionic-0098.adnet.avionic-design.de>
Message-ID: <alpine.LNX.2.01.1208011127270.31519@frira.zrqbmnf.qr>
References: <20120731151600.GA19412@redhat.com> <20120731170741.GA4735@x1.osrc.amd.com> <20120801074335.GG29673@avionic-0098.adnet.avionic-design.de>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-08-01 09:43, Thierry Reding wrote:
>> > 
>> > PWM Support (PWM) [N/y/?] (NEW) ?
>> > 
>> > CONFIG_PWM:
>> > This enables PWM support through the generic PWM framework.
>> 
>> Oh, there's one more enlightening sentence in the help:
>> 
>> "You only need to enable this, if you also want to enable one or more of
>> the PWM drivers below."
>> 
>> Got it? :-)
>> Thierry, can you guys please fix this?
>
>Hehe, those aren't very descriptive, that's true. I was going to go over
>the documentation anyway, so I'll make a note to revise the Kconfig help
>texts as well.

Also, instead of
	bool "PWM Support"
this should be
	menuconfig "PWM support"

so that you can disable the whole submenu at once.

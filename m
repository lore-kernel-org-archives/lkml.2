Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202Ab2KNMMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:12:42 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57277 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161153Ab2KNMMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <50A1D4E4.50308@wwwdotorg.org>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
 <1352638249-29298-11-git-send-email-jonas.gorski@gmail.com> <50A1D4E4.50308@wwwdotorg.org>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Wed, 14 Nov 2012 13:12:20 +0100
Message-ID: <CAOiHx==UhqBWMAgqGaVM+P=eUueq1uKTDUaTg+ROsHYitUi+MQ@mail.gmail.com>
Subject: Re: [RFC] MIPS: BCM63XX: switch to common clock and Device Tree
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2012 06:04, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/11/2012 05:50 AM, Jonas Gorski wrote:
>> Switch BCM63XX to the common clock framework and use clkdev for
>> providing clock name lookups for non-DT devices.
>>
>> Clocks can have a frequency and gate-bit, or none, in case they
>> are just provided for drivers expecting them to be present.
>
>> diff --git a/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt b/Documentation/devicetree/bindings/clock/bcm63xx-clock.txt
>
> A very minor nit, but it might be nice to add the DT binding
> documentation before (or as part of) the patches that use them (code
> that parses them, or using the bindings in .dts files)
>
> Of course, I'm relying on my email receive order, to judge this since
> the patch numbering didn't come through, so perhaps the patches are
> already set up this way...

No you are right, the bindings are being added earlier. I move it to
the patch adding the (then still unused) binding to the dts(i) files.
I'd rather not split it up completely, and add it with the binding
usage together so it's easier to spot if I do something with the
bindings that contradicts the documentation or is missing ;-).


Jonas

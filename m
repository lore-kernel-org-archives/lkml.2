Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2GPSaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:30:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64743 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GPSae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:30:34 -0400
User-Agent: Microsoft-MacOutlook/14.2.3.120616
Date: Mon, 16 Jul 2012 20:30:19 +0200
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
From: Benjamin Beurdouche <dev@thecercle.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@amd64.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, <david@lang.hm>
Message-ID: <CC2A2A5B.58B7%dev@thecercle.org>
Thread-Topic: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
In-Reply-To: <CC2A171A.580D%torvalds@linux-foundation.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="ISO-8859-1"
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,
I usually don't take part of discussions in LKML but I recognized myself
in what Linus is actually describing as a "normal user" (one of the few
insane enough to read the mailing list...) so I wrote a few ideas below...
Please give me your thoughts Š Benjamin

On 7/16/12 6:50 PM, "Linus Torvalds" <torvalds@linux-foundation.org> wrote:
>Your "problem" isn't what any sane person cares about, and isn't what
>I started the RFC for.
>Seriously. NOBODY CARES.
>You can do what you want to do *today*. Just edit the config file, or
>use any of the millions of config tools. Stop whining.

I guess the complexity of configuration in order to build a distro is why
I didn't even try to build a distro-specific kernelŠ Moreover the doc is
terrible for unfamiliar users...

>The thing I'm asking for is for normal people. Make it easy for people
>who DO NOT CARE about the config file to just build a kernel for their
>machine.

If you think about users like me who just want to build a basic featured
kernel we always do a make menuconfig with near default options...


What I would expect to build a distro/kernel is to have access in a
menuconfig-like to 
1) basic features like networking, usb storage, power management ŠetcŠ
_enabled by default_  so I can quickly build a "common platform" kernel
which gives me everything I need on my laptopŠ and
2) have a menu like "*distro* basic requirements" (never changes and only
for a few big distros) and finally
3) have a "*distro* advanced" menu having all the other non-mandatory
options available but with a conflict managerŠ (it could check against a
full Kconfig file kept up-to-date by each distro groups)

Without necessary talking of menuconfig, I liked very much the structure
Linus suggested in the first post regarding Kconfig filesŠ

That maybe some idiotic suggestions but I'd like to know what you think
about it anywayŠ

Cheers! B.

>Don't complicate the issue by bringing up some totally unrelated
>question. Don't derail a useful feature for the 99% because you're not
>in it.
>
>                    Linus



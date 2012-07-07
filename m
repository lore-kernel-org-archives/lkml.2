Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2GGDxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 23:53:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43972 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GGDxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 23:53:08 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
Date: Fri, 6 Jul 2012 20:53:08 -0700
Message-ID: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin,

On Fri, Jul 6, 2012 at 2:05 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This set of patches implements the core Linux support for the AArch64
> (64-bit ARM) architecture.

Hmm. I didn't see a cc to current ARM maintainer (Russell), nor did
you cc the topic list that you list in the MAINTAINERS entry. It's
probably considered appropriate to do both. Also,
linux-arch@vger.kernel.org usually has a cc of new architectures.

> ARM introduced AArch64 as part of the ARMv8 architecture

With the risk of bikeshedding here, but I find the name awkward. How
about just naming the arch port arm64 instead? It's considerably more
descriptive in the context of the kernel.  For reference, we didn't
name ppc64, nor powerpc, after what the IBM/power.org marketing people
were currently calling the architecture at the time either.

[...]

> There is no hardware platform available at this point. From a kernel
> perspective, the aim is to minimise (or even completely remove) the
> platform code from the architecture specific directory. FDT is currently
> mandated and there are ongoing discussions for ACPI support.

This will be interesting to see how it plays out over time, and how
many vendors will drop in arm64 cores on their existing designs and
thus need to pull over infrastructure from arch/arm for their platform
type. A lot of the drivers have moved out to common code so much of it
should be possible to do cleanly, but there is still some risk for
duplication.

I guess it's a good chance to clean up some of it and start from a
clean slate, if you can avoid the temptation of just moving over code.


-Olof

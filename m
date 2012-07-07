Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2GGXmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:42:39 -0400
Received: from seven.medozas.de ([5.9.24.206]:52565 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab2GGXmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:42:38 -0400
Date: Sun, 8 Jul 2012 01:42:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Olof Johansson <olof@lixom.net>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1207080140420.26355@frira.zrqbmnf.qr>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-07-07 05:53, Olof Johansson wrote:
>
>> ARM introduced AArch64 as part of the ARMv8 architecture
>
>With the risk of bikeshedding here, but I find the name awkward. How
>about just naming the arch port arm64 instead? It's considerably more
>descriptive in the context of the kernel.  For reference, we didn't
>name ppc64, nor powerpc, after what the IBM/power.org marketing people
>were currently calling the architecture at the time either.

But then again, we went with the clumsy "x86_64" instead of the
well-credited "amd64". :)

(What was the name IBM used to call their hardware at that time?)

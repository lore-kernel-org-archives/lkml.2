Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2GJPak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:30:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56964 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2GJPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:30:38 -0400
Date: Tue, 10 Jul 2012 16:33:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
In-Reply-To: <20120710101018.GE15120@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de>
	<20120710071023.GA10456@gmail.com>
	<20120710101018.GE15120@arm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the AArch32 kernel port many implementation decisions newer
> architectures were made in a way that preserves backwards compatibility
> to over 15 years ago (and for *good* reasons, ARMv4 hardware is still in
> use). But keeping the same decisions in AArch64 is wrong.

Same argument as x86-32 v x86-64. Same issues about compatibility.

> AArch64 is also in its early days with a lot of developments to come
> (and still waiting for hardware). Until we really know the final shape,
> the AArch64 code base must allowed to evolve independently from the
> AArch32 one.

That is one area where while the merge was needed and a lot of work the
original split may well have been sensible for x86-64 as well.

> The initial target is servers (see the companies that have announced
> plans around ARMv8) but I agree, we may see it in other devices in the
> future. But as the maintainer I have no plans to support a 32-bit SoC on
> an AArch64/ARMv8 system (which may or may not support AArch32 at kernel
> level). If an AArch64 SoC would share some devices with an AArch32 SoC,
> such code will go to drivers/.

What plans to other maintainers and board vendors have ? Any design choice
has to cope with these happening if a third party goes and does it.

Alan



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1CNLZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:25:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44084 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab1CNLZM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Mon, 14 Mar 2011 07:25:12 -0400
Message-Id: <4D7E095802000078000363D5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 14 Mar 2011 11:26:00 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <sedat.dilek@gmail.com>
Cc: "Alan Modra" <amodra@bigpond.net.au>, "Ingo Molnar" <mingo@elte.hu>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "binutils" <binutils@sourceware.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
In-Reply-To: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.03.11 at 12:02, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> [1] Jan, what do you mean by "side-effects". Can you explain that a
> bit more precisely?

The -B compiler option controls more than just finding "helper" binaries.

> [2] Where can someone set a "global behaviour" (hardcoded options) for
> his/her assembler in the kernel's build-system (speaking of
> "--size-check=[error|warning]")?

Nowhere, selecting behavior is possible only via the command line.

> [3] Can the kernel-buildsystem check for system's binutils/as version
> and/or its features/options? If yes, where would that be and can you
> offer a snippet for a solution?

Making the kernel build system check for certain newly introduced
gas options would again require changes to the kernel sources,
which is precisely what is impossible to do for past kernel releases
(and bisection in particular).

Jan


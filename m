Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab1LVTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:16:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:37160 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1LVTQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:16:54 -0500
Message-ID: <1324581399.24803.38.camel@twins>
Subject: Re: [RFC][PATCH] sparc64: remove __ARCH_WANT_UNLOCKED_CTXSW usage
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 22 Dec 2011 20:16:39 +0100
In-Reply-To: <20111221.180549.2295489434558987482.davem@davemloft.net>
References: <1323702852.13285.25.camel@twins>
	 <20111221.164426.1859065550459950375.davem@davemloft.net>
	 <20111221.180549.2295489434558987482.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 18:05 -0500, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 21 Dec 2011 16:44:26 -0500 (EST)
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Mon, 12 Dec 2011 16:14:12 +0100
> > 
> >> The only thing resting me is asking you to simply test the below patch
> >> and report what happens. Hopefully things will simply work.. if not I've
> >> messed up and need to go look harder :/
> > 
> > I'll give it a spin, and get back to you, thanks!
> 
> Ok, so far so good, I stressed out my Niagara-T3 box for a while doing gcc
> bootstraps, running the testsuite, etc. and all seems well so far.
> 
> I'll keep beating on it and let you know if anything funny happens, but for
> now as far as I'm concerned:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks David!! 

I'll probably post again (and propose merger) once Catalin's patches
that remove __ARCH_WANT_INTERRUPTS_ON_CTXSW from ARM have landed.

ARM being the last user of that feature, and with only SPARC64 and IA64
(needlessly) using __ARCH_WANT_UNLOCKED_CTXSW we could finally remove
some of that hairy code from the core scheduler.



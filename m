Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1KPTll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:41:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:60228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1KPTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:41:40 -0500
Date: Wed, 16 Nov 2011 20:41:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Fenghua Yu <fenghua.yu@intel.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix typo/thinko in get_random_bytes()
In-Reply-To: <4EC41060.2040501@zytor.com>
Message-ID: <alpine.LFD.2.02.1111162039240.4902@ionos>
References: <4ec4061010261a4cb0@agluck-desktop.sc.intel.com> <4EC41060.2040501@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Nov 2011, H. Peter Anvin wrote:

> On 11/16/2011 10:50 AM, Luck, Tony wrote:
> > If there is an architecture-specific random number generator we use
> > it to acquire randomness one "long" at a time. We should put these
> > random words into consecutive words in the result buffer - not just
> > overwrite the first word again and again.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> Ouch.  Good catch.  This, I guess, is the downside of doing this only on
> the kernel paths... made this kind of errors harder to catch.
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1LLR2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:28:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab1LLR2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:28:21 -0500
Date: Mon, 12 Dec 2011 18:26:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
Message-ID: <20111212172630.GF23870@elte.hu>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
 <1323684086.3669.16.camel@mfleming-mobl1.ger.corp.intel.com>
 <4EE63552.5000704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE63552.5000704@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/12/2011 02:01 AM, Matt Fleming wrote:
> > 
> > At this late -rc stage I agree it makes sense to revert this. The
> > CONFIG_X86_32 oops that the patch fixes has been around for years and no
> > one seems to have encountered it (until now), whereas this new
> > regression is likely to affect many more users.
> > 
> 
> Agreed on both accounts.
> 
> For the revert:
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ... or we can push it in the next x86/urgent batch.

I've pushed it int x86/urgent and will send it to Linus later 
today (if he has not applied it meanwhile).

Thanks,

	Ingo

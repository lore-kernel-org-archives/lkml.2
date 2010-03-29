Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0C2Qrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:47:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0C2Qrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:47:51 -0400
Date: Mon, 29 Mar 2010 18:47:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20100329164738.GA3527@elte.hu>
References: <20100326154354.GA10959@elte.hu>
 <alpine.LFD.2.00.1003290844420.3579@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003290844420.3579@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ingo, what's the state of the "fix CONFIG_NO_BOOTMEM=y" patches? I've seen 
> the patches several times, but I've been expecting to pull them from the 
> -tip tree rather than apply them directly.

Thanks, i missed their .34 relevance and was concentrating too much on the 
whole series ...

> It's mainly the "avoid infinite loop" thing, but Yinghai seems to think the 
> three first patches of his (currently 31-patch) series are all 2.6.34 
> material.
> 
> Ping?

I'm on them now - just applied the three patches & tidied up the changelogs - 
will send them later today or tomorrow at the latest after some testing (if 
you dont beat me to it).

Thanks,

	Ingo

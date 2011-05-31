Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1EaMuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:50:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1EaMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:50:30 -0400
Date: Tue, 31 May 2011 14:50:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ted Ts'o" <tytso@mit.edu>, David Woodhouse <dwmw2@infradead.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531125019.GB10249@elte.hu>
References: <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
 <20110531075306.GB20798@elte.hu>
 <1306832148.2029.484.camel@i7.infradead.org>
 <20110531121215.GA4215@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531121215.GA4215@thunk.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, May 31, 2011 at 09:55:47AM +0100, David Woodhouse wrote:
> > On Tue, 2011-05-31 at 09:53 +0200, Ingo Molnar wrote:
> > > I'll always prefer typing:
> > >   make ARCH=x86_64 ...
> > > To:
> > >   make ARCH=x86 CONFIG_64BIT=y ...
> > 
> > You're not building on an x86 box? I always suspected you had some alien
> > technology! Does it run Linux?
> > 
> > Why else would you need to specify ARCH=x86 on the latter command line? 
> 
> I don't know why Ingo needs ARCH=x86 on the command line, [...]

I replied to the hypothetical scenario where CONFIG_64BIT=y works and 
ARCH=x86_64 and ARCH=i386 are deprecated because they are supposedly 
a 'dirty hack' and 'obsolete'. (David's words, not mine)

I vehemently disagree with the deprecation of ARCH=i386 and 
ARCH=x86_64 and with the characterisation as well.

> [...] but I regularly type "make ARCH=i386" when building 32-bit 
> kernels on a 64-bit system, and my scripts use "make ARCH=x86_64" 
> when building 64-bit kernels (just in case I happen to have booted 
> a 32-bit kernel).

Ditto here. They are not just useful but logical as well. This is 
what the whole thread is about: i want this behavior to be 
*preserved*.

Thanks,

	Ingo

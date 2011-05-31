Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab1EaHxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:53:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999Ab1EaHxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:53:20 -0400
Date: Tue, 31 May 2011 09:53:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531075306.GB20798@elte.hu>
References: <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> And then this legacy trick of using the obsolete $ARCH settings to 
> override the setting of CONFIG_64BIT can be deprecated.

Sigh, nope. The two legacies we have should simply be turned into 
trivial aliases that map to the newfangled CONFIG_*=y way of doing 
things.

I'll always prefer typing:

  make ARCH=x86_64 ...

To:

  make ARCH=x86 CONFIG_64BIT=y ...

And others have expressed that in this thread too.

Really, guys, please stop breaking existing tools!

There is no problem to solve here, having ARCH=i386 and ARCH=x86_64 
around does not hurt anyone, is well established and actively helps 
people so what's your problem?

I'll be happy to learn the new methods and will happily add them to 
the toolbox of existing methods.

Thanks,

	Ingo

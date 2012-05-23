Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631Ab2EWUKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:10:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:46580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab2EWUK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:10:29 -0400
Date: Wed, 23 May 2012 22:10:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: Ingo Molnar <mingo@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
In-Reply-To: <4FBCFC4A.7070303@redhat.com>
Message-ID: <alpine.LFD.2.02.1205232140570.3231@ionos>
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521215127.GH17031@redhat.com> <alpine.LFD.2.02.1205220012020.3231@ionos> <20120521222449.GJ17031@redhat.com> <alpine.LFD.2.02.1205220044460.3231@ionos>
 <4FBB6E8B.8020200@redhat.com> <20120523144846.GA26974@gmail.com> <4FBCFC4A.7070303@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Avi Kivity wrote:
> On 05/23/2012 05:48 PM, Ingo Molnar wrote:
> >> 
> >> This is silly.  Most of the time the kernel is advanced by 
> >> incremental patches.  Sometimes it is advanced by minor or 
> >> major refactoring.  It is never advanced by personal attacks 
> >> on contributors.
> > 
> > Thomas wasn't so much doing a personal attack, it was pointing 
> > out stupidity and then it was mocking the repeated stupidity. He 
> > very politely explained his point of view (with which I agree), 
> 
> I guess we disagree on what is polite or not.  Mocking, for example,
> isn't part of it in my book.

I really avoid flaming as far as it goes, but I consider that ignoring
a thorough patch review and replying only on the very obvious problem
is a massive form of impoliteness. Replying on a still polite reminder
with a sloppy "I just took what's there and implemeted the
optimization which I was tasked with" is even more of an offense. It
clearly shows that there is no interest in making the whole thing
better and just aims for quick and dirty "here are my benchmark
results" success.

This is what actually triggered me to switch into grumpy mode.

I'm really tired of that attitude. It's the root cause for the steady
increasing mess in the kernel.

It forces people who actually care to waste an endless amount of time
to clean up what has been just slapped into the code base quick and
dirty. And you expect those people to stay calm and polite if they get
ignored and ridiculed with sloppy replies?

You may be a saint, but I'm definitely too old to cope with that.

Thanks,

	tglx

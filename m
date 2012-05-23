Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2EWOs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:48:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59221 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2EWOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:48:53 -0400
Date: Wed, 23 May 2012 16:48:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120523144846.GA26974@gmail.com>
References: <20120521163727.GA13337@redhat.com>
 <alpine.LFD.2.02.1205211940030.3231@ionos>
 <20120521215127.GH17031@redhat.com>
 <alpine.LFD.2.02.1205220012020.3231@ionos>
 <20120521222449.GJ17031@redhat.com>
 <alpine.LFD.2.02.1205220044460.3231@ionos>
 <4FBB6E8B.8020200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB6E8B.8020200@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 05/22/2012 02:01 AM, Thomas Gleixner wrote:
> > > 
> > > Others are not my fault :)
> > > 
> > > Seriously, if Avi/Marcelo want to rewrite the ISR emulation
> >
> > Interesting POV, really.
> >
> > Did you ever notice that the kernel is a collaborative effort and not
> > controlled by "Avi/Marcelo"?
> >
> > Did you ever notice that arch/x86/kvm is part of arch/x86? 
> 
> This is silly.  Most of the time the kernel is advanced by 
> incremental patches.  Sometimes it is advanced by minor or 
> major refactoring.  It is never advanced by personal attacks 
> on contributors.

Thomas wasn't so much doing a personal attack, it was pointing 
out stupidity and then it was mocking the repeated stupidity. He 
very politely explained his point of view (with which I agree), 
and then you guys pressed the issue and there's just so many 
hours in the merge window, so you asked to be flamed ...

Avi, if you cannot be brought to properly reject incomplete 
patches going in the wrong direction then others maintainers 
interested in the code will do it.

If you start to consistently require from KVM contributors 
"incremental updates" in the right direction, not piling crap on 
crap, then such incidents won't happen. This isn't the first 
such incident but there's hope that it might be the last one.

The rule in arch/x86/ (and many other subsystems) is very 
simple: we don't speed up crappy code. If you want to speed it 
up then make it clean first, *then* is it suited for speedups. 
Crappy code is fragile and bound to introduce bugs, and crappy 
code leads to continued increased maintenance overhead, so 
crappy code is basically under a perpetual code freeze until 
it's uncrapped.

Thanks,

	Ingo

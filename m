Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2EWXCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:02:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:47220 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2EWXCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:02:53 -0400
Date: Thu, 24 May 2012 01:02:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
In-Reply-To: <20120523204311.GB350@redhat.com>
Message-ID: <alpine.LFD.2.02.1205240001090.3231@ionos>
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521215127.GH17031@redhat.com> <alpine.LFD.2.02.1205220012020.3231@ionos> <20120521222449.GJ17031@redhat.com> <alpine.LFD.2.02.1205220044460.3231@ionos>
 <4FBB6E8B.8020200@redhat.com> <20120523144846.GA26974@gmail.com> <4FBCFC4A.7070303@redhat.com> <alpine.LFD.2.02.1205232140570.3231@ionos> <20120523204311.GB350@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Michael S. Tsirkin wrote:

> On Wed, May 23, 2012 at 10:10:27PM +0200, Thomas Gleixner wrote:
> > Replying on a still polite reminder with a sloppy "I just took what's
> > there and implemeted the optimization which I was tasked with" is even
> > more of an offense.
> 
> Ow.  That 'not my fault' line was a joke.

Which I obviously missed to get after spending quite some time to grok
the whole thing.

I still don't get it. Must be a cultural or an age thing or both.


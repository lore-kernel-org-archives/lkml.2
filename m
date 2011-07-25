Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab1GYIMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:12:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GYILz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:11:55 -0400
Date: Mon, 25 Jul 2011 10:11:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Asias He <asias.hejun@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725081102.GA3895@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CC489.1090509@codemonkey.ws>
 <CAOJsxLH-poY4-wEUPqAa8bzK+1WJ0UYtSuue72RYwcd_D0kx_A@mail.gmail.com>
 <4E2D1D07.9020009@redhat.com>
 <CAFO3S428qqUAu19QjPxDDAVv+eJSX0MEfYp5y03znNi6XbEtTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFO3S428qqUAu19QjPxDDAVv+eJSX0MEfYp5y03znNi6XbEtTg@mail.gmail.com>
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


* Asias He <asias.hejun@gmail.com> wrote:

> On Mon, Jul 25, 2011 at 3:36 PM, Avi Kivity <avi@redhat.com> wrote:
> 
> > On 07/25/2011 10:27 AM, Pekka Enberg wrote:
> >
> >> Hi Anthony,
> >>
> >> On Mon, Jul 25, 2011 at 4:19 AM, Anthony Liguori<anthony@codemonkey.ws>
> >>  wrote:
> >> >  lguest already does this and lives in the kernel.
> >>
> >> Does Lguest have SMP, usermode networking, and GUI support?
> >>
> >>
> > IIRC, yes, no, and no.
> >
> >
> And Lguest only supports 32-bit kernel.

The answer to SMP is 'no' as well, as lguest supports only a single 
CPU:

   [Documentation/virtual/lguest/lguest.c]

        /* We're CPU 0.  In fact, that's the only CPU possible right now. */
        cpu_id = 0;

Thanks,

	Ingo

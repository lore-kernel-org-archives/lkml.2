Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab1CNSE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:04:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35136 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757174Ab1CNSEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:04:25 -0400
Date: Mon, 14 Mar 2011 18:03:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Modra <amodra@gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314180323.31785f81@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH@mail.gmail.com>
References: <20110311165802.GA3508@intel.com>
	<4D7A64670200007800035F4C@vpn.id2.novell.com>
	<AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
	<4D7DE39302000078000362E6@vpn.id2.novell.com>
	<20110314095534.GB18058@elte.hu>
	<20110314104131.GG6275@bubble.grove.modra.org>
	<AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I disagree.  The whole world is not the linux kernel.  I think HJ is
> > bending over backwards to even offer a switch that turns the error
> > into a warning.
> 
> So what do you suggest that testers who want to, say, build old Linux
> kernel versions with new binutils do?

Use an older binutils. It's already the case you can't build old kernels
with current gcc and binutils, there have been repeated such events over
time and nobody has had too much trouble.

Alan

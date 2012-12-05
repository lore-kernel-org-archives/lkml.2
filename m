Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2LEVgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:36:08 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54039 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LEVgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:36:05 -0500
Date: Wed, 5 Dec 2012 21:41:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205214114.0bb545f1@pyramind.ukuu.org.uk>
In-Reply-To: <20121205211244.GA6239@liondog.tnic>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
	<20121205142935.GA12119@liondog.tnic>
	<20121205152756.5afec12c@pyramind.ukuu.org.uk>
	<20121205153121.GA28556@liondog.tnic>
	<20121205154749.2af4ef36@pyramind.ukuu.org.uk>
	<20121206075721.18c0c05aa767b330f47d77eb@canb.auug.org.au>
	<20121205211244.GA6239@liondog.tnic>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 22:12:45 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Dec 06, 2012 at 07:57:21AM +1100, Stephen Rothwell wrote:
> > On Wed, 5 Dec 2012 15:47:49 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > And yes btw we should turn this option on in -next, and get these sort of
> > > things out of the tree for good. More importantly it'll mean anyone
> > > adding another one gets a whine on the spot.
> > 
> > While I appreciate your confidence, I don't notice quite a few new
> > warnings (because there are so many of them already :-().  Is there some
> > reason to not turn this on in our "normal" builds?  Does it produce many
> > false positives?
> 
> Yes, it produces a huge number of warnings which need weeding out (some
> of them are false positives and some of them are simply unfixable due to
> design decisions in the kernel, etc, etc):
> 
> $ make W=123 drivers/pnp/pnpacpi/core.o 2> w.log

I was just talking about the always true/always false stuff !

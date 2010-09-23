Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0IWKfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:35:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51290 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753078Ab0IWKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:35:35 -0400
Date: Thu, 23 Sep 2010 11:58:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923102708.GC25663@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	<20100920150431.GD31167@sirena.org.uk>
	<20100920152726.68ac2d84@linux.intel.com>
	<20100920152705.GJ3414@rakim.wolfsonmicro.main>
	<AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
	<20100922231514.5e9967c7@linux.intel.com>
	<20100923060703.GB11198@angua.secretlab.ca>
	<20100923095411.GA25663@rakim.wolfsonmicro.main>
	<20100923112703.543b0b86@lxorguk.ukuu.org.uk>
	<20100923102708.GC25663@rakim.wolfsonmicro.main>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 11:27:08 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Sep 23, 2010 at 11:27:03AM +0100, Alan Cox wrote:
> 
> > > To be honest I'd actually be inclined to go more towards the way the
> > > non-DT embedded platforms have gone and just ignore the data we get
> > > from SFI as much as possible and have board specific initialisation in
> > > code; it's boring and repetitive but it's also clear and *relatively*
> > > robust.
> 
> > And even more unmaintainable. Won't happen.
> 
> So what is the plan for coping with OEM systems?  Right now the code
> makes no provision at all that I can see for system-specific handling
> of the SFI data which seems very optimistic.

There are various system specific drivers which have their own sfi entry
and name. Telling platforms apart is a problem with SFI but the latest
firmware also supports DMI so we can get platform identification via the
normal PC interfaces.

Alan

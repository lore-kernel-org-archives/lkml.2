Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1LETJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:09:02 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47527 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126Ab1LETJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:09:00 -0500
Date: Mon, 5 Dec 2011 19:10:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for Sept 28 (mrst)
Message-ID: <20111205191033.191615af@lxorguk.ukuu.org.uk>
In-Reply-To: <20111205184105.GA20121@elte.hu>
References: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au>
	<4E839B94.9040305@xenotime.net>
	<4EDD0FED.7060301@xenotime.net>
	<20111205184105.GA20121@elte.hu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 19:41:05 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > On 09/28/2011 03:11 PM, Randy Dunlap wrote:
> > > On 09/28/11 03:04, Stephen Rothwell wrote:
> > >> Hi all,
> > > 
> > > 
> > > When CONFIG_X86_INTEL_MID=y but CONFIG_X86_MRST is not enabled
> > > (this is on an i386/X86_32 build):
> > > 
> > > rtc.c:(.init.text+0x6234): undefined reference to `__mrst_cpu_chip'
> > > 
> > > Full randconfig file is attached.
> > 
> > Hm, it's now 20111205 and this build error is still around.
> > Is there any hope for getting it fixed?
> 
> Alan?

Don't think I saw the original report - I'll take a look. I imagine it's
just an X86_MRST that didn't get changed rightly.


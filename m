Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1KPLJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:09:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44849 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755755Ab1KPLJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:09:09 -0500
Date: Wed, 16 Nov 2011 11:10:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Klaus Ripke <klaus@ripke.com>
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: LOAD_FREQ (4*HZ+61) avoids loadavg Moire
Message-ID: <20111116111023.502d6a6e@lxorguk.ukuu.org.uk>
In-Reply-To: <20111116110330.GA235@aine.Speedport_W_502V_Typ_A>
References: <20111112143825.GX6192@aine.Speedport_W_502V_Typ_A>
	<4EC0CD04.4090107@ladisch.de>
	<20111116110330.GA235@aine.Speedport_W_502V_Typ_A>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 12:03:30 +0100
Klaus Ripke <klaus@ripke.com> wrote:

> On Mon, Nov 14, 2011 at 09:10:44AM +0100, Clemens Ladisch wrote:
> > Klaus Ripke wrote:
> > > With some seconds based load (like SSL heartbeats)
> > > and LOAD_FREQ at (5*HZ+1) I see Moire patterns like inverse sawtooth,
> > 
> > Thanks for researching this, but I don't see them because I'm too lazy
> > to reproduce this.  Could you please publish a colorful screenshot
> > somewhere?
> 
> there you go http://ripke.com/loadavg/moire

And for any load you pick you'll be able to generate patterns and
inaccurate load average data unless you actually count used cycles via
the perf counters and such on processors.

Shannon says we can't win. Changing the computation may well change load
values other users use in order to predict and balance workloads so while
it has clear limits futzing with it to make one workload look better is
simply going to break stuff for other people.

Alan

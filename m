Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2JaRoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:44:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33546 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320Ab2JaRoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:44:13 -0400
Date: Wed, 31 Oct 2012 17:49:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121031174919.51f1518d@pyramind.ukuu.org.uk>
In-Reply-To: <20121031173750.GB18615@srcf.ucam.org>
References: <20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
	<20121031170334.59833fb1@pyramind.ukuu.org.uk>
	<20121031171048.GA17163@srcf.ucam.org>
	<20121031172121.14cc1215@pyramind.ukuu.org.uk>
	<20121031171743.GA17652@srcf.ucam.org>
	<20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
	<20121031173750.GB18615@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 17:37:50 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Oct 31, 2012 at 05:39:19PM +0000, Alan Cox wrote:
> > On Wed, 31 Oct 2012 17:17:43 +0000
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > By booting a signed kernel, not turning on swap and writing directly to 
> > > the swap partition.
> > 
> > Ok so the actual problem is that you are signing kernels that allow the
> > user to skip the S4 resume check ?
> 
> What S4 resume check?

One you would add .. but no I'm wrong there - its a problem at the
suspend point so you do need a signature for it. Oh well yet another
reason it's nto useful.

Alan

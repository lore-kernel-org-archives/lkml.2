Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2DJNWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:22:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33507 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2DJNWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:22:37 -0400
Date: Tue, 10 Apr 2012 14:25:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
In-Reply-To: <20120410131206.GB31551@sirena.org.uk>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
	<20120410131206.GB31551@sirena.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 14:12:06 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, Apr 10, 2012 at 02:20:05PM +0100, Alan Cox wrote:
> > This ended in a discussion of where shall we put it and then silence so
> > resending this because we still need it and we've got patches that depend
> > upon it getting backlogged.
> 
> The decision seems fairly settled that general purpose ADCs like this

It's far lower level than things like IIO. It provides very low level
services to other drivers not to user space. You could in theory write an
IIO driver to use the interface but at the moment all the consumers are
low level hardware drivers and likely to remain so.

Alan

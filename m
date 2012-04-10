Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2DJONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:13:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36460 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2DJOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:12:59 -0400
Date: Tue, 10 Apr 2012 15:15:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
In-Reply-To: <20120410140749.GL7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
	<20120410131206.GB31551@sirena.org.uk>
	<20120410142501.6045c6c0@pyramind.ukuu.org.uk>
	<20120410133339.GK7499@opensource.wolfsonmicro.com>
	<20120410144235.1e05efd4@pyramind.ukuu.org.uk>
	<20120410140749.GL7499@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you be more specific about what this early boot time stuff is?
> Looking at the changelogs in there it all looks like the standard
> battery monitoring and power supply stuff that these ADCs get used for -
> just based on the changelogs there doesn't appear to be anything
> remarkable here.

It depends on the actual device but things the like battery management
are a key one.

> We can't just keep on going round adding new custom interfaces every
> time someone supports a new SoC - it means we end up having to sit and

We can't go around blocking entire platforms because of the IIO blob. I
raised this point with the whole previous *generation* of Intel SoC
devices about IIO and nothing has been done about it.

Get IIO out of staing and we can look at it, until then IIO is staging
code, it's not part of the kernel, it may never be part of the kernel,
and it should never block actual kernel code.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab2DJNkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:40:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41750 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2DJNkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:40:08 -0400
Date: Tue, 10 Apr 2012 14:42:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
In-Reply-To: <20120410133339.GK7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
	<20120410131206.GB31551@sirena.org.uk>
	<20120410142501.6045c6c0@pyramind.ukuu.org.uk>
	<20120410133339.GK7499@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, but fundamentally it's just a general purpose ADC which looks
> just the same as all the other SoC/PMIC ADCs.  Like I say the decision
> for that hardware was to push it in via IIO. 

Your decision maybe. And it's one that makes no sense.

As I said this is a low level interface for driver enabling including
early boot time stuff, and its on a platform that's unlikely to want or
ever use and suck in the big blob of IIO code.

If you want an IIO interface to it you can write one, it's just a low
level resource manager.

Alan

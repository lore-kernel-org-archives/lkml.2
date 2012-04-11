Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab2DKM2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:28:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36740 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2DKM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:28:13 -0400
Date: Wed, 11 Apr 2012 13:30:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120411133035.25fa00b0@pyramind.ukuu.org.uk>
In-Reply-To: <4F8568A8.5060206@cam.ac.uk>
References: <20120410131206.GB31551@sirena.org.uk>
	<20120410142501.6045c6c0@pyramind.ukuu.org.uk>
	<20120410133339.GK7499@opensource.wolfsonmicro.com>
	<20120410144235.1e05efd4@pyramind.ukuu.org.uk>
	<20120410140749.GL7499@opensource.wolfsonmicro.com>
	<20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
	<20120410151943.GM7499@opensource.wolfsonmicro.com>
	<20120410175632.5c11c36e@pyramind.ukuu.org.uk>
	<20120410175846.GQ7499@opensource.wolfsonmicro.com>
	<20120411112411.11825eec@pyramind.ukuu.org.uk>
	<20120411103827.GH3163@opensource.wolfsonmicro.com>
	<4F856173.8000901@cam.ac.uk>
	<20120411121309.4b8f8e40@pyramind.ukuu.org.uk>
	<4F8568A8.5060206@cam.ac.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> needs to be abstracted as well.  Consumers might not care that the gain 
> just doubled because someone else requested it, but I suspect many of them will.

At the bottom layer I'd expect a second consumer of the same data to get
-EBUSY, but you are then going to tell me there are ADCs with one gain
control for several channels no doubt 8)


> end up with most of IIO.  That's effectively what we did...   It's big 
> because there are
> actually not that many 'simple' adc's out there.

Fair enough - you would be the expert there.

Alan

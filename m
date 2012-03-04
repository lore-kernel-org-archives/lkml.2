Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2CDVEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 16:04:51 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32919 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab2CDVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 16:04:50 -0500
Date: Sun, 4 Mar 2012 21:06:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "John G. Heim" <jheim@math.wisc.edu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: speakup bug
Message-ID: <20120304210649.35b88230@pyramind.ukuu.org.uk>
In-Reply-To: <D9E4F6D133A2410EA4A56217E18CBAD7@hinkle>
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
	<20120303173916.7eca9391@pyramind.ukuu.org.uk>
	<D9E4F6D133A2410EA4A56217E18CBAD7@hinkle>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2012 20:03:48 -0600
"John G. Heim" <jheim@math.wisc.edu> wrote:

> From: Alan Cox
> Sent: Saturday, March 03, 2012 11:39 AM
> Subject: Re: speakup bug
> 
> >> returns an error code. But it looks as if the region for a serial port,
> >> 0x3f8 - 0x3ff,  in ioport_resource cannot be reserved because the entire
> >> range from 0x000 through 0xcf7 is already taken by something named "PCI 
> >> Bus
> >> 0000:00".  Therefore calling request_resource always fails and the driver
> > f>or the speech synth errors out.
> >
> >It's a heirarchical space, so you can allocate things within it. Look
> >at /proc/ioports.
> 
> # file /proc/ioports
> /proc/ioports: empty

Try cat on it not file

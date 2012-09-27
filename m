Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2I0OKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:10:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46328 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2I0OKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:10:02 -0400
Date: Thu, 27 Sep 2012 15:14:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927151447.2460ce44@pyramind.ukuu.org.uk>
In-Reply-To: <20120927140502.GB12552@moon>
References: <20120913125401.GK19956@moon>
	<20120913172507.5039e3c6@pyramind.ukuu.org.uk>
	<20120922180639.GC11610@moon>
	<20120922200731.GD14004@kroah.com>
	<20120922201144.GD11610@moon>
	<20120922215232.GA25778@moon>
	<20120923010953.GA17663@kroah.com>
	<20120923064007.GA2994@moon>
	<34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
	<20120924141441.GD16532@moon>
	<20120927140502.GB12552@moon>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, Greg, what's opinion? This flags fetching is the same as say fetching
> of termios settings, once fetched they can be changed immediately, and it's
> up to caller what to do with termios settings. No?

I think you need to explain what you expect to be doing with it, and why
it is safe in that application.

Alan

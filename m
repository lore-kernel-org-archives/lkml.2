Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2D1Tal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 15:30:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42137 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2D1Taj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 15:30:39 -0400
Date: Sat, 28 Apr 2012 20:33:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120428203322.7680594f@pyramind.ukuu.org.uk>
In-Reply-To: <20380.13347.472373.965813@elektron.ikp.physik.tu-darmstadt.de>
References: <1335632134-2488-1-git-send-email-preston.fick@silabs.com>
	<20120428190502.32eaf294@pyramind.ukuu.org.uk>
	<20380.13347.472373.965813@elektron.ikp.physik.tu-darmstadt.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2012 20:17:07 +0200
Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de> wrote:

> >>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> ...
>     Alan> The other question is whether having some custom gpio poking
>     Alan> interface is actually a good idea. I suspect probably not. The
>     Alan> kernel gpio layer can help a bit but doesn't really solve the
>     Alan> problem as there is no way to tie a gpio to a port. Given how many
>     Alan> devices seem to have gpios these days I wonder if we need a gpio
>     Alan> setting interface via termiox.
> 
> Is this really kernel stuff or better handled in libusb(x)

Tricky to do it that way when the kernel driver owns the interface. Also
it's looking increasingly like we'll need to support a variety of "serial
and a couple of extra magic lines" type interfaces for things like SIM
readers.

Alan

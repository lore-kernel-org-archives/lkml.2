Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2IVXNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 19:13:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40420 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2IVXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 19:12:56 -0400
Date: Sun, 23 Sep 2012 00:15:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120923001534.776ac2a3@pyramind.ukuu.org.uk>
In-Reply-To: <20120922200731.GD14004@kroah.com>
References: <20120913095623.GB28508@moon>
	<20120913135131.5b251797@pyramind.ukuu.org.uk>
	<20120913125401.GK19956@moon>
	<20120913172507.5039e3c6@pyramind.ukuu.org.uk>
	<20120922180639.GC11610@moon>
	<20120922200731.GD14004@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Guys, you mean something like below? Look, I must admit I'm not really
> > sure if I've done all locking right, and there is no need for additional
> > kref counting on tty_struct. Could you please check if it looks more-less
> > sane (I've tested it but still...)

This still doesn't answer the question about 'why is this actually
useful'. It can change as or after you query it so the value is useless.

Alan

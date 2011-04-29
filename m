Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab1D2VbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:31:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46890 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757640Ab1D2VbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:31:24 -0400
Date: Fri, 29 Apr 2011 22:32:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: johnlinn@comcast.net
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        michal simek <michal.simek@petalogix.com>, joe@perches.com,
        grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
Message-ID: <20110429223222.7d283dde@lxorguk.ukuu.org.uk>
In-Reply-To: <1426670407.2093674.1304112562934.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
References: <20110429211434.GA1355@kroah.com>
	<1426670407.2093674.1304112562934.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes I'll have a look at it, sorry for the hassle.  
> 
> I'm assuming I need to try it against linus
> tree as something may have changed. Or some other tree?

Or you are assuimg NO_IRQ is defined everywhere which it isn't. The
kernel mainstream just uses zero as intended not a define for it.

Alan

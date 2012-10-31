Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab2JaQ4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:56:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33401 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2JaQ4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:56:54 -0400
Date: Wed, 31 Oct 2012 17:01:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Konstantin Ryabitsev <mricon@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: new daily bugzilla.kernel.org annoyance messages
Message-ID: <20121031170159.582acdf6@pyramind.ukuu.org.uk>
In-Reply-To: <20121031164504.GB1119@kroah.com>
References: <20121031163005.GA411@kroah.com>
	<5091535C.9050103@kernel.org>
	<20121031164504.GB1119@kroah.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Let me see if setting "whinedays" to "0" will turn off the automated
> > whines while letting people set up custom whines as they needed. If that
> > doesn't work, then I'll set "whinedays" to 3650, so at least this way
> > the only bugs you'll get whines about will be those that have been "NEW"
> > for over 10 years. :)
> 
> Thanks, that would be good.  I didn't see anywhere where I could turn
> the "whine" option off, or change it, what screen is it on?

Turning off by default would indeed be a good thing™.

Is there any chance of also setting it so that anyone who is assigned a
bug can close it not just a few people with magical powers and the filer ?

Alan

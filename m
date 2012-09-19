Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2ISNyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:54:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36202 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2ISNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:54:50 -0400
Date: Wed, 19 Sep 2012 14:59:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20120919145925.35e95b5a@pyramind.ukuu.org.uk>
In-Reply-To: <20120919143136.46dd2318963c0d8524492041@canb.auug.org.au>
References: <20120919143136.46dd2318963c0d8524492041@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012 14:31:36 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/usb/serial/vizzini.c: In function 'vizzini_set_termios':
> drivers/usb/serial/vizzini.c:454:22: error: invalid type argument of '->' (have 'struct ktermios')
> 
> Caused by commit c05fecb1d57e ("USB: serial: add vizzini driver")
> interacting with commit adc8d746caa6 ("tty: move the termios object into
> the tty") from the tty tree.
> 
> I added the following merge fix patch and can carry it as necessary:

Vizzini seems to have teleported into Greg's tree. Greg - it's got a pile
of other bugs in it plus complete bogus comments and the like. You don't
seem to have every posted it to the lists for comment or if you did it
didn't turn up here ?

Alan

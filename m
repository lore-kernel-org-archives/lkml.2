Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965619Ab0HFTch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:32:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47191 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935867Ab0HFTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:32:23 -0400
Date: Fri, 6 Aug 2010 20:45:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100806185147.GB23853@suse.de>
References: <20100805213528.GA13794@kroah.com>
	<AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com>
	<20100806185147.GB23853@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010 11:51:47 -0700
Greg KH <gregkh@suse.de> wrote:

> On Fri, Aug 06, 2010 at 11:40:15AM -0700, Linus Torvalds wrote:
> > 
> > Do do the highlander thing on that crud. Cut it off at the head, and
> > make sure it never ever comes back to life.
> 
> Arnd and Alan, I'll drop the BKL portion of this patch series and
> regenerate something to get the other tty patches to Linus.

Wouldn't it make more sense to simply turn it on as Linus suggested ?

Alan

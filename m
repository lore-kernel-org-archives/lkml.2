Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2GRUdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:33:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39437 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab2GRUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:33:34 -0400
Date: Wed, 18 Jul 2012 21:37:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Terry Phelps <tgphelps50@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: QUESTION: Why might Linux suddenly stop replying to pings for
 no apparent reason?
Message-ID: <20120718213716.09236b88@pyramind.ukuu.org.uk>
In-Reply-To: <CAMUfR_uwW10hLCRbtMsj_2Qgg1CbA3qFz1RyRp2dq=tvh98K=g@mail.gmail.com>
References: <CAMUfR_vogZUgJB5QBr-QrYqFEM71J_pyvc=cFRV6apvb=pVJuQ@mail.gmail.com>
	<CAFLxGvzOzNj5ab82RDV=kn_a6Bb16sKT=GfK3igVM3pk7CkC4Q@mail.gmail.com>
	<CAMUfR_to9bD2PE8+6Y4we0YG-ULkAVxASByK4_mn7WTmyS9g5Q@mail.gmail.com>
	<20120718171432.09e4790e@pyramind.ukuu.org.uk>
	<CAMUfR_uwW10hLCRbtMsj_2Qgg1CbA3qFz1RyRp2dq=tvh98K=g@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012 16:30:59 -0400
Terry Phelps <tgphelps50@gmail.com> wrote:

> On Wed, Jul 18, 2012 at 12:14 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> If I should be posting my question to somewhere other than the
> >> linux-kernel mailing list, please advise me where that might be. It
> >> sure looks like something in the kernel isn't working properly
> >> somewhere.
> >
> > If you can duplicate the problem with an *upstream* kernel then yes it
> > is. If you only see it on an Oracle kernel then talk to Oracle.
> >
> > Alan
> 
> Alan,
> Thank you for your help. I am not a kernel hacker by any means, but
> will try to do what you suggest.
> Should I clone the current kernel git tree, and build the latest
> kernel? Or build from some other point in time?

I'd grab a modern release kernel - the current 3.4 version is probably
best. Building off the git tree tends to add other "interesting"
variables you don't need.

Alan

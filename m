Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2EJLhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:37:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37692 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932Ab2EJLhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:37:38 -0400
Date: Thu, 10 May 2012 12:40:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Grundler <grantgrundler@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile failure on PA-RISC
Message-ID: <20120510124016.0fe9a2a1@pyramind.ukuu.org.uk>
In-Reply-To: <CAP6odjhVK0PjXQ_vLbK2dWs4CnnxJwmhcDPDV=qLJmxBMBBDJQ@mail.gmail.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
	<20120505115851.1fecbe50@pyramind.ukuu.org.uk>
	<Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
	<20120506132413.28499956@pyramind.ukuu.org.uk>
	<CAP6odjhVK0PjXQ_vLbK2dWs4CnnxJwmhcDPDV=qLJmxBMBBDJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012 10:38:30 -0700
Grant Grundler <grantgrundler@gmail.com> wrote:

> On Sun, May 6, 2012 at 5:24 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> What NO_IRQ problem do you mean? There is
> >> #define NO_IRQ          (-1)
> >> in arch/parisc/include/asm/irq.h.
> >
> > It should be zero ready for us to get rid of it. Aa far as I can tell
> > pa-risc can just move to 0 without anything breaking. In fact some stuff
> > like serial port polling on 8250 ports will begin to work if it's done.
> 
> Alan,
> Didn't this patch of yours go in?
>     http://www.spinics.net/lists/linux-parisc/msg03894.html

Last I checked it hadn't - hence the request to test it when I saw
someone actually running parisc.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731Ab1KJOZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:25:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60055 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab1KJOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:25:41 -0500
Date: Thu, 10 Nov 2011 14:25:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: linux-next: Tree for Oct 11 (ata/pata_of_platform.c)
Message-ID: <20111110142539.2d49a62e@lxorguk.ukuu.org.uk>
In-Reply-To: <20111110135703.GA23609@elte.hu>
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
	<4E94A920.40503@xenotime.net>
	<4E987829.3080104@xenotime.net>
	<20111110135703.GA23609@elte.hu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> > > drivers/ata/pata_of_platform.c:55:13: error: 'NO_IRQ' undeclared (first use in this function)
> > 
> > 
> > [adding Author: Anton]
> > 
> > Build error still present in linux-next of 20111014.
> 
> This build failure regression report was ignored twice and then 
> pushed upstream and is still unfixed a month after the initial 
> report. Upstream now fails to build on like 25% of x86 configs.
> 
> What's going on with this bug guys?

As I've said before the driver shouldn't be trying to use "NO_IRQ", Not
having an irq is 0 as in if (!dev->irq)


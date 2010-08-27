Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0H0AAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:00:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49671 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628Ab0H0AAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:16 -0400
Date: Fri, 27 Aug 2010 01:15:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped
 controllers
Message-ID: <20100827011517.6265da18@lxorguk.ukuu.org.uk>
In-Reply-To: <611842.81625.qm@web180307.mail.gq1.yahoo.com>
References: <20100826220747.6da28e97@lxorguk.ukuu.org.uk>
	<611842.81625.qm@web180307.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 15:58:51 -0700 (PDT)
David Brownell <david-b@pacbell.net> wrote:

> 
> 
> --- On Thu, 8/26/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>  (Which calls
> > into addition.
> > 
> > I think you need a reality check.
> 
> I know you don't say that every time someone makes
> different assumptions about context than you have.

I don't think its assumptions. In this case it's a case of actually
looking at what these devices are in the real world. Hence 'reality
check'.

Sure there are plenty of 're-usable' components that appear everywhere -
Designware etch turns up in everything but this isn't one of them.

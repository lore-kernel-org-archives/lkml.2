Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab0IGXwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:52:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44914 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757363Ab0IGXwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:52:02 -0400
Date: Wed, 8 Sep 2010 01:11:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        "avictor.za@gmail.com" <avictor.za@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
Message-ID: <20100908011112.6469db62@lxorguk.ukuu.org.uk>
In-Reply-To: <616992.75276.qm@web180302.mail.gq1.yahoo.com>
References: <20100907222230.4a3594be@lxorguk.ukuu.org.uk>
	<616992.75276.qm@web180302.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 16:44:55 -0700 (PDT)
David Brownell <david-b@pacbell.net> wrote:

> 
> 
> --- On Tue, 9/7/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > 
> > >      device->output_pin = -EINVAL;
> > 
> > gpio numbers are unsigned in the rest of the API
> 
> Minor goof; should have been "int" everywhere,
> as implied by the references to negative numbers
> in the docs... negatives not used internally, but
> preserved for external use (as above).

Ok I need to patch a couple of the intel drivers to use -1 then.

Alan

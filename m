Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab2LIK6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 05:58:05 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57882 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab2LIK6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 05:58:04 -0500
Date: Sun, 9 Dec 2012 11:03:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: anish kumar <anish198519851985@gmail.com>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
Message-ID: <20121209110319.459a762a@pyramind.ukuu.org.uk>
In-Reply-To: <1355047099.1673.5.camel@anish-Inspiron-N5050>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
	<CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
	<20121207145955.GA28704@roeck-us.net>
	<20121207164906.08b65046@pyramind.ukuu.org.uk>
	<1355047099.1673.5.camel@anish-Inspiron-N5050>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Dec 2012 01:58:19 -0800
anish kumar <anish198519851985@gmail.com> wrote:

> On Fri, 2012-12-07 at 16:49 +0000, Alan Cox wrote:
> > > I could imagine declaring the activity request buttons to be "input", but for
> > > presence detects it is a bit far fetched and would add too much complexity.
> > 
> > Android tries to address this with its switch class driver, but I'm not
> > sure its actually got anything over making them input devices.
> 
> Sorry for not understanding the context here.How the debounce sysfs
> added by Guenter has anything to do with switch driver in android?

The other more general option is to make the input layer do the debounce
and make them all inputs rather than just relying on any gpio layer
support.



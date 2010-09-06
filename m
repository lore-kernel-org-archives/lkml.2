Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0IFO3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:29:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52718 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146Ab0IFO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:29:04 -0400
Date: Mon, 6 Sep 2010 15:48:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [IIO] Proposal for sysfs attributes
Message-ID: <20100906154800.53522fc7@lxorguk.ukuu.org.uk>
In-Reply-To: <4C84F80C.2050702@cam.ac.uk>
References: <4C84A93B.2050507@iis.fraunhofer.de>
	<4C84E64D.4040600@jic23.retrosnub.co.uk>
	<20100906143256.6b49825d@lxorguk.ukuu.org.uk>
	<4C84F80C.2050702@cam.ac.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm afraid I have lost you here.  Why restrict to powers of 10?  The buffered
> route is going to ship whatever the chip actually produces.

Then I don't see the point of IIO over a million random misc API's of the
week. Giving 50,000 interfaces the same name doesn't actually achieve
anything or solve any real problems.

The job of the OS is to provide an *abstraction*. If IIO won't do that I
don't see the point of IIO.

The current situation is

	Random gadget added with own API
	Qt sensors module is written for said gadget

IIO is offering no improvement if it won't abstract in a controlled
fashion.


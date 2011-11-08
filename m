Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1KHNso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:48:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37073 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927Ab1KHNsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:48:42 -0500
Date: Tue, 8 Nov 2011 13:48:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, alan@linux.intel.com,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some
 variables
Message-ID: <20111108134804.07095c5d@lxorguk.ukuu.org.uk>
In-Reply-To: <4EB90902.4030200@evidence.eu.com>
References: <4E492CFF.7040905@pwrnet.de>
	<20110822211832.GA8023@kroah.com>
	<4EB3A009.10502@evidence.eu.com>
	<4EB8F6B9.6010008@atmel.com>
	<4EB90902.4030200@evidence.eu.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The modifications that I have proposed are very minimal, and most 
> user-space code should continue to work without any difference. Any Cris 
> user-space code will continue to work, because we didn't change the 
> behavior of the driver. For Atmel user-space code, instead, the behavior 
> of the driver changes only if flags are not set and delay variables 
> contain a value different than 0 (which, hopefully, is not a very common 
> situation). That's the reason why I preferred to not change the names of 
> the variables, even if better names would be desirable.

We have inconsistency between implementations. We don't have a change in
implementation. There isn't any way to resolve that except by fixing the
deviating implementation and doing it promptly.

With my tty hat on I'm quite happy with this patch. The sooner it is
upstream the better.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1LEMZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:25:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46690 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132Ab1LEMZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:25:14 -0500
Date: Mon, 5 Dec 2011 12:26:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wolfgang Denk <wd@denx.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Heiko Schocher <hs@denx.de>,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] RFC, watchdog: add generic wdt driver API
Message-ID: <20111205122649.6fc6aed2@lxorguk.ukuu.org.uk>
In-Reply-To: <20111204170810.8370625EA22@gemini.denx.de>
References: <1322992423-21683-1-git-send-email-hs@denx.de>
	<20111204125928.GB5788@pengutronix.de>
	<20111204170810.8370625EA22@gemini.denx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> that we have a number of customers who consider the existing wdt
> support unsufficient for their use cases.  We've been using it on all
> kinds on PPC systems, and now on ARM as well.
> 
> We will not fight for inclusion of this driver, we just wat to know if
> it's worth investing efforts to get it accepted or if this is a lost
> case.

I think it would be better to start from the needed feature list than the
implementation of an old and wildly different pile of code. Then discuss
adding those features that are relevant to the current framework - which
ought to be relatively easy now each watchdog is a set of methods.

Alan

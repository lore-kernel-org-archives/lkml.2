Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab1KJIxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:53:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58230 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269Ab1KJIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:53:14 -0500
Date: Thu, 10 Nov 2011 08:54:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111110085411.6cf41819@lxorguk.ukuu.org.uk>
In-Reply-To: <1320893521.32205.1196.camel@vkoul-udesk3>
References: <20111109121329.GC21630@sirena.org.uk>
	<1320854413.32205.948.camel@vkoul-udesk3>
	<20111109164211.GA4016@opensource.wolfsonmicro.com>
	<20111109165518.GA13451@kroah.com>
	<20111109165829.GC4016@opensource.wolfsonmicro.com>
	<20111109173037.66bea268@lxorguk.ukuu.org.uk>
	<20111109225933.GA17769@opensource.wolfsonmicro.com>
	<20111109230318.1168fd9e@lxorguk.ukuu.org.uk>
	<20111109230329.GB17769@opensource.wolfsonmicro.com>
	<20111109230558.2fb94c0b@lxorguk.ukuu.org.uk>
	<20111109231124.GC17769@opensource.wolfsonmicro.com>
	<20111109232533.16780313@lxorguk.ukuu.org.uk>
	<1320893521.32205.1196.camel@vkoul-udesk3>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I plan to rework this interface this month and fix it much before 3.3 :)
> 
> If you guys agree we can live with non compiling driver for little
> while, otherwise we can use Alans fixes.

Greg - probably simplest to defer blowing away the staging driver until
3.3 window then - just kill spectra this time ?

Alan

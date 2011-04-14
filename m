Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab1DNOyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:54:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47526 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754203Ab1DNOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:54:24 -0400
Date: Thu, 14 Apr 2011 15:55:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Cc: Joe Perches <joe@perches.com>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Mangalampalli, Jayant" <jayant.mangalampalli@intel.com>,
        "Gokulrangan, Venkat R" <venkat.r.gokulrangan@intel.com>,
        "Cox, Alan" <alan.cox@intel.com>, "Gross, Mark" <mark.gross@intel.com>,
        "Beare, Bruce J" <bruce.j.beare@intel.com>
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Message-ID: <20110414155503.55518951@lxorguk.ukuu.org.uk>
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA32316154CEF1CF@rrsmsx501.amr.corp.intel.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
	<1302731811.11415.38.camel@Joe-Laptop>
	<20110413222332.GA32013@kroah.com>
	<1302733836.11415.42.camel@Joe-Laptop>
	<20110413224621.GA4909@kroah.com>
	<1302736379.11415.57.camel@Joe-Laptop>
	<8A0E4C92AE2D6D40AF99653191DA32316154CEF1CF@rrsmsx501.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the logging is a distraction. Everyone is I think happy with the
other minor tidying and the move from staging ? If so lets just get it
moved while Greg and Joe throw buns at each other 8)

For the record IMHO custom _dbg wrappers are usually not justified but I
think I agree with Joe on this one because we have some many
&foo->bar->baz it eliminates.

Anyway - that can wait.

Alan

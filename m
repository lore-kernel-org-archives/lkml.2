Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1LBRVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:21:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40958 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109Ab1LBRVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:21:43 -0500
Date: Fri, 2 Dec 2011 17:23:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20111202172323.34f75234@lxorguk.ukuu.org.uk>
In-Reply-To: <20111124162014.GA2750@Boggieman>
References: <20111121182910.GA2856@Boggieman>
	<20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
	<CAMeQTsb64v_9NQKU1xtBQdEPcnjxDAQZ8HBuMJBsD6_m117SRQ@mail.gmail.com>
	<20111124162014.GA2750@Boggieman>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I suspect this is just DVI with a HDMI connector. That is the case for Fit-PC2.
> > It is hooked up to the SDVO and provides video but no audio.

I've now got an HDMI capable display *and* the right cables. Testing the
Dell mini 10 shows that it works although it's defaulting to the wrong
mode and there is stuff on the display below the picture that shouldn't
be.

So I now also have a debug case for the scaling or whatever is actually
going on problem.

Alan

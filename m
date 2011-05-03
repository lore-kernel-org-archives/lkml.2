Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1ECW6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:58:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54605 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583Ab1ECW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:58:05 -0400
Date: Tue, 3 May 2011 23:59:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503235917.0493fd0d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503223237.GA25039@kroah.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
	<20110503163128.24853.15446.stgit@bob.linux.org.uk>
	<20110503174254.GA6545@kroah.com>
	<20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
	<20110503213925.GA7453@opensource.wolfsonmicro.com>
	<20110503225316.5371c96b@lxorguk.ukuu.org.uk>
	<20110503220233.GB14080@kroah.com>
	<20110503222635.GA8035@opensource.wolfsonmicro.com>
	<20110503223237.GA25039@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not really that interested in the Intel patches in staging, the bulk
> > of them require a from scratch rewrite to go upstream as they're so far
> > from following the Linux driver model for these things.
> 
> Ok, then I guess I can handle them.
> 
> Alan, how do you want to go about sending patches that we can apply
> somehow?

Best bet is to apply Mark's patch into your git tree then apply mine on
top I think. Git will see the same patch in both trees and resolve it all
nicely for -next.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1DMNUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:20:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35191 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370Ab1DMNUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:20:09 -0400
Date: Wed, 13 Apr 2011 14:20:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@linux.jf.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] gma500: backlight warning
Message-ID: <20110413142022.56ebe93f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110413131714.GA17918@srcf.ucam.org>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
	<20110413093555.28527.30662.stgit@localhost.localdomain>
	<20110413131714.GA17918@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 14:17:14 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Apr 13, 2011 at 10:36:19AM +0100, Alan Cox wrote:
> >  	props.max_brightness = 100;
> > +	props.type = BACKLIGHT_PLATFORM;
> 
> No, this should be BACKLIGHT_RAW - it's hitting the control registers 
> directly rather than going via a platform interface.

Ah ok - I figured it *was* the platform backlight. I'll send Greg a new
version of that changeset.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab2KEMCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:02:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39246 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2KEMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:02:40 -0500
Date: Mon, 5 Nov 2012 12:07:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Fleming <matt@console-pimps.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Message-ID: <20121105120736.33af173b@pyramind.ukuu.org.uk>
In-Reply-To: <1352116219.14888.262.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	<CAHR064isMXk8qkqhBJ==9sRRP7xC_j_K5rqXApza-LNkosp5mg@mail.gmail.com>
	<20121104193741.7b4ca37b@pyramind.ukuu.org.uk>
	<CAHR064jwe=diZ9B-D+-SroCW1ZevkRDMosB7uDuc2VXZkFxmdA@mail.gmail.com>
	<20121105103031.GA25659@kroah.com>
	<1352116219.14888.262.camel@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is the 'efi_enabled' variable, but it doesn't strictly mean
> "this_is_a_uefi_system()", it actually means "Do we have EFI runtime
> services?". The whole thing is a bit of a mess and I'm planning on
> cleaning it up this week.


As far as I can understand it we should be reserving those areas on a
UEFI booted machine and just marking them as busy so that they are not
available to any drivers to go peering into.

Alan


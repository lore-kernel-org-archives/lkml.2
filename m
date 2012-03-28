Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2C1OvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:51:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2C1OvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:51:11 -0400
Date: Wed, 28 Mar 2012 15:53:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        patrik.r.jakobsson@gmail.com, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20120328155336.41063e3a@pyramind.ukuu.org.uk>
In-Reply-To: <20120328132840.GA26353@avionic-0098.mockup.avionic-design.de>
References: <20111121182910.GA2856@Boggieman>
	<20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
	<20120328132840.GA26353@avionic-0098.mockup.avionic-design.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From a quick look this seems to be developed for Poulsbo, but since you
> mention GMA600 explicitly, is it supposed to work on newer hardware as
> well? I'm specifically interested in the Atom N2600 which has a GMA3600
> (0x8086:0x0be1 to be exact).

I believe there are GMA600 and 3600 bits buried in the packages for
Maemo/Meego/Tizen vaapi code but I've not looked.

> I'm also not sure which kernel driver this was developed against. It
> looks like it might have been against the initial staging variant. At
> least it still has some references to TTM, so I guess anyone wanting to
> port it to the new kernel driver would have to convert those to GEM.

The one for the 3D/2D non-free user space driver. I've been working on
Cedartrail primarily at the moment so not had time to dig further into
the video playback logic. I did get the decoder detected and mapped
happily but haven't yet had time to persuade the firmware to upload.

It'll also need the driver extending to support the overlay planes
feature in the DRI/DRM layer.

> Do you think that would be doable? Can you say if the GMA3600 is
> sufficiently similar to make that driver work

I don't know for sure.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1CAOgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:36:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54699 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182Ab1CAOgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:36:04 -0500
Date: Tue, 1 Mar 2011 14:35:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, Alan Cox <alan@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: gma500: Rip out the memory manager
Message-ID: <20110301143559.7a546401@lxorguk.ukuu.org.uk>
In-Reply-To: <20110301142908.GA13144@kroah.com>
References: <20110224162440.27093.80825.stgit@localhost.localdomain>
	<20110224162457.27093.32399.stgit@localhost.localdomain>
	<20110301020302.GA11353@kroah.com>
	<20110301122437.4477fa65@bob.linux.org.uk>
	<20110301141527.GA12881@kroah.com>
	<20110301142908.GA13144@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your patch removes two lines from drivers/staging/gma500/psb_drm.h with
> the following diff:
> --- a/drivers/staging/gma500/psb_drm.h
> +++ b/drivers/staging/gma500/psb_drm.h
> @@ -28,9 +28,6 @@
>  #include "drm_mode.h"
>  #endif
>  
> -#include "psb_ttm_fence_user.h"
> -#include "psb_ttm_placement_user.h"
> -
>  #define DRM_PSB_SAREA_MAJOR 0
>  #define DRM_PSB_SAREA_MINOR 2
>  #define PSB_FIXED_SHIFT 16
> 
> 
> Yet those #defines are not present in this file right now.  That's not a
> whitespace change...

Need to sort some other drivers out but I'll send you the regenerated
patches in a bit once I'e pulled todays -next and see what is up. Makefile
one does seem odd as nothing else should be touching that area.

Missed the spaces patch first time around dunno where it went.

Alan

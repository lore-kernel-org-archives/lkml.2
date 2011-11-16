Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1KPXsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:48:04 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36420 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab1KPXsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:48:02 -0500
X-Sasl-enc: pF/N6Ua1p6KifXVvDvq5l6kosNPpjJDEkbVkEvDbyDGE 1321487280
Date: Wed, 16 Nov 2011 15:45:49 -0800
From: Greg KH <greg@kroah.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-audio: Fix audio codec breakage
Message-ID: <20111116234549.GB3533@kroah.com>
References: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com>
 <1848643.7W84dlC6t3@barack>
 <4EBCE0E6.5020202@bitmer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EBCE0E6.5020202@bitmer.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:46:30AM +0200, Jarkko Nikula wrote:
> On 11/02/2011 09:41 AM, Péter Ujfalusi wrote:
> >On Wednesday 19 October 2011 11:44:05 Jarkko Nikula wrote:
> >>Commit 57fe725 ("MFD: twl4030-codec ->  twl4030-audio: Rename the driver")
> >>broke the device registration for twl4030 codec if twl6040 is not set.
> >>
> >>Reason for breakage is that commit didn't update the changed config name for
> >>macro twl_has_codec().
> >>
> >>Signed-off-by: Jarkko Nikula<jarkko.nikula@bitmer.com>
> >>Cc: Peter Ujfalusi<peter.ujfalusi@ti.com>
> >>---
> >>I don't know is this too late for 3.1 or would it be better to queue for
> >>stable when it's out? Anyway breakage happened in 3.1-rc cycle and
> >>unfortunately I noticed it only now.
> >
> >Thanks Jarkko for noticing this. I have overlooked it probably because I'm
> >using omap2plus_defconf for most of the time.
> >
> >The breakage also present in 3.0. Can we queue this patch for stable 3.0.x,
> >and 3.1.x?
> >
> >Acked-by: Peter Ujfalusi<peter.ujfalusi@ti.com>
> >
> Actually this is already fixed by f09ee04 ("mfd: Fix twl4030
> dependencies for audio codec") which is now in 3.2-rc. Is that
> commit queued for stable too?

Now it is :)

thanks,

greg k-h

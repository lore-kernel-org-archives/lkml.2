Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1BTDvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 22:51:48 -0500
Received: from foo.stuge.se ([213.88.146.6]:57064 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750952Ab1BTDvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 22:51:47 -0500
Message-ID: <20110220035143.15480.qmail@stuge.se>
Date: Sun, 20 Feb 2011 04:51:43 +0100
From: Peter Stuge <peter@stuge.se>
To: Indan Zupancic <indan@nul.nu>, Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/i915 Screen corruption introduced by
	a00b10c360b35d6431a94cb
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl> <20110219182511.GA3977@viiv.ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110219182511.GA3977@viiv.ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter wrote:
> Please provide the usual details about your system (especially what gpu
> this is on). Also, screenshots of what typical corruptions look like can
> help a lot in tracking down such things.

Confirm I also have this issue on my X40, but there are other bugs
that are much more significant so I haven't bothered mentioning this.

On the other hand my kernel is nearly two months old.

Please don't mistake this as a complaint. I'm overall rather happy
even with current state and it's issues, and especially I think the
situation is consistently getting better, with some bumps here and
there along the way.

Last time I used a projector I had some trouble, because the graphics
driver was too clever; it automatically set the correct resolution
for the projector, but I needed the resolution of my internal screen. :)


//Peter

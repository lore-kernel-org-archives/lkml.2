Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2HFMXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:23:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41175 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2HFMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:23:22 -0400
Date: Mon, 6 Aug 2012 13:23:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120806122317.GA11339@srcf.ucam.org>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
 <20120803162702.GA22896@srcf.ucam.org>
 <20120804165727.GA4980@thinkpad-t410>
 <20120805211412.GG12232@phenom.ffwll.local>
 <20120805211838.GA27188@srcf.ucam.org>
 <20120805214016.GH12232@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120805214016.GH12232@phenom.ffwll.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 11:40:16PM +0200, Daniel Vetter wrote:

> As long as it's only apple shipping multi-gpu machines with
> broken/non-existing vbt, I'll happily stomach the quirk list entries.
> They're bad, but imo the lesser evil.

Doing this via quirks means that we'll always be broken on the hardware 
at the point where it ships. Implementing the functionality means we 
stand some chance of working out of the box.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

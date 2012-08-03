Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2HCQ1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:27:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50683 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2HCQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:27:06 -0400
Date: Fri, 3 Aug 2012 17:27:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120803162702.GA22896@srcf.ucam.org>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803162451.GF8165@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:24:51AM -0500, Seth Forshee wrote:

> This is one of the things I wasn't so sure about. There are various
> checks in intel_lvds_init() that can cause it to bail out before we try
> to get the EDID, and I don't fully understand all of them. If non-laptop
> machines are expected to bail out before the EDID check then the
> approach I've taken seems reasonable. Otherwise adding a quirk probably
> is a good idea.

I know we've previously had problems with machines with phantom LVDS 
hardware, but I'm not sure what the current state of affairs is.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

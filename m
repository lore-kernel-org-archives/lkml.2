Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825Ab1ACXWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 18:22:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:9483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1ACXWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 18:22:49 -0500
Message-Id: <0d30dc$kl33rh@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,268,1291622400"; 
   d="scan'208";a="693211025"
Date: Mon, 03 Jan 2011 23:22:38 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
Cc: Linus Torvalds <torvalds@linux-foundation.org>, airlied@linux.ie,
        eric@anholt.net, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de,
        Jean Delvare <khali@linux-fr.org>,
        David Brownell <david-b@pacbell.net>
In-Reply-To: <4D22571F.9060706@t-online.de>
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com> <4D22119B.9050007@t-online.de> <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com> <849307$b0clt4@azsmga001.ch.intel.com> <4D22571F.9060706@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jan 2011 00:09:19 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> Kernel 2.6.37-rc8-git2
> =================
> 
> text mode console: ok, resolution 1280x1024, fully used by framebuffer
> output
> X: first device detected is LVDS with resolution 1024x768. VGA and DVI
> connector work in X,
> but X switches to 1024x768 for both of them. xrandr reports the four
> physical connectors but
> also LVDS, VGA2 and TV3 connectors.

A false detection of the LVDS would appear to be a minor issue compared to
all the trouble you have. Can you add drm.debug=0xe to your boot
commandline and attach the resulting dmesg?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

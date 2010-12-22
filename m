Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0LVQ7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:59:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:58596 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0LVQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:59:18 -0500
Message-Id: <c6d829$pujifv@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,214,1291622400"; 
   d="scan'208";a="870959615"
Date: Wed, 22 Dec 2010 16:59:06 +0000
To: Takashi Iwai <tiwai@suse.de>, Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm fixes
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <s5hei99vkqj.wl%tiwai@suse.de>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie> <s5hei99vkqj.wl%tiwai@suse.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 17:24:36 +0100, Takashi Iwai <tiwai@suse.de> wrote:
> The commit 448f53a1ede54eb854d036abf54573281412d650
>   drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
> 
> causes a regression on a SandyBridge machine here.
> The laptop display (LVDS) becomes blank.  Reverting the commit fixes
> the problem.

The question is whose BIOS is wrong? The Lenovo U160's or the
Sandybridge SDV? And why does it work for that other OS? <Insert
rhetorical question of the day here.>

It's back to the square one for one or the other platform...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

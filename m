Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2INNBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:01:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:14189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2INNBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:01:50 -0400
Message-Id: <84c8a8$5o3dgr@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="193050139"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
To: Grant Likely <grant.likely@secretlab.ca>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca>
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca>
Date: Fri, 14 Sep 2012 14:01:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012 13:57:06 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
> Some platforms (for instance MacbookPros) have custom backlight drivers
> and don't use the integrated i915 backlight control. This patch adds a
> quirk to disable registering the intel backlight when unused on a
> platform.
> 
> Tested on MacbookPro8,3. Without this patch both the intel_backlight and
> gmux_backlight devices get registered and userspace doesn't know which
> it should use.

Userspace is informed throught the backlight/type property.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

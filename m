Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1I0QrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:47:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:40941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1I0QrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:47:17 -0400
Message-Id: <e0d58a$1mfd94@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57128228"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-7-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-7-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:47:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:43 -0700, Keith Packard <keithp@keithp.com> wrote:
> The PCH refclk settings are global, so we need to look at all of the
> encoders, not just the current encoder when deciding how to configure
> it. Also, handle systems with more than one panel (any combination of
> PCH/non-PCH eDP and LVDS).

As I read it, this sets the refclk not on the active configuration, but
on all the hardware detected for the system whether enabled or not.

There are two basic changes here, the cleanup and improvement to the logic
based on what type of output is connected and the second change to
determine which outputs are active.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

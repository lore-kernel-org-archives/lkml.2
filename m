Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1ITQY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:24:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:3354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab1ITQY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:24:27 -0400
Message-Id: <d08817$1gj40m@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,412,1312182000"; 
   d="scan'208";a="50958358"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Enable digital port hotplug on PCH systems
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <1316533641-13478-1-git-send-email-keithp@keithp.com>
References: <1316533641-13478-1-git-send-email-keithp@keithp.com>
Date: Tue, 20 Sep 2011 17:24:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 08:47:21 -0700, Keith Packard <keithp@keithp.com> wrote:
> We were relying on the BIOS to set these bits, which doesn't always
> happen.

Do we need to clear IRQ bits on uninstall, for example to prevent
"Interrupt 19: no one cared!" or is that due to a different cause?

More of a general question really. The patch itself looks good and
matches against the spec afaics.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1I0QkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:40:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:48934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1I0QkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:40:06 -0400
Message-Id: <c55c5d$k5e8g@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="21149968"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 3/9] drv/i915: Pull display_clock_mode out of VBT table
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-4-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-4-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:40:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:40 -0700, Keith Packard <keithp@keithp.com> wrote:
> This tells the driver whether a CK505 clock source is available on
> pre-PCH hardware. If so, it should be used as the non-SSC source,
> leaving the internal clock for use as the SSC source.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Chris Wison <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

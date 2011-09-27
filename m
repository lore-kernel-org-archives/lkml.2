Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1I0Qxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:53:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:22518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1I0Qxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:53:50 -0400
Message-Id: <c55c5d$k5ihq@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="21154362"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 8/9] drm/i915: All PCH refclks are 120MHz
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-9-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-9-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:53:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:45 -0700, Keith Packard <keithp@keithp.com> wrote:
> I can't find any reference clocks which run at 96MHz as seems to be
> indicated from the comments in this code.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

I think there exists a 100MHz test mode (certainly there is reference to
such in the diagram and DPCTL). But as we never use that, this should be
true.

I could find no reference at all to the 96MHz clock, so from that
perspective,
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

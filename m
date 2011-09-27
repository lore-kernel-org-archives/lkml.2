Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1I0Ql3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:41:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:22351 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1I0Ql2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:41:28 -0400
Message-Id: <c55c5d$k5em6@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="21150406"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 5/9] drm/i915: Allow SSC parameter to override VBT value
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-6-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-6-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:41:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:42 -0700, Keith Packard <keithp@keithp.com> wrote:
> Allow SSC to be enabled even when the BIOS disables it for testing SSC paths.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

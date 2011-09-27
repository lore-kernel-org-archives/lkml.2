Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1I0QjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:39:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:5015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1I0QjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:39:22 -0400
Message-Id: <e39f63$23uf1d@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="71253037"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/9] drm/i915: Use DRM_DEBUG_KMS for all messages in intel_bios.c
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-3-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-3-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:39:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:39 -0700, Keith Packard <keithp@keithp.com> wrote:
> These are all KMS related anyways, so don't hide them under other
> debug levels.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

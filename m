Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1IWSyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:54:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:10219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab1IWSyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:54:36 -0400
Message-Id: <aefc95$1knjug@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="55300048"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: use DDC_ADDR instead of hard-coding it
To: Matt Turner <mattst88@gmail.com>, Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, Matt Turner <mattst88@gmail.com>
In-Reply-To: <1316798320-21704-1-git-send-email-mattst88@gmail.com>
References: <1316798320-21704-1-git-send-email-mattst88@gmail.com>
Date: Fri, 23 Sep 2011 19:54:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011 13:18:40 -0400, Matt Turner <mattst88@gmail.com> wrote:
> Signed-off-by: Matt Turner <mattst88@gmail.com>

We should just make intel_ddc_probe() a wrapper around drm_probe_ddc().
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

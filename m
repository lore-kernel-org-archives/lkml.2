Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1FPQjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:39:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:58518 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab1FPQju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:39:50 -0400
Message-Id: <aefc95$f0ne9@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,376,1304319600"; 
   d="scan'208";a="15752649"
Date: Thu, 16 Jun 2011 17:39:45 +0100
To: Leandro Lucarella <luca@llucax.com.ar>
Subject: Re: Graphic corruption with i915 (2.6.39.1)
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org
References: <20110616145842.GM20487@llucax.com.ar> <013811$g9fu7@fmsmga002.fm.intel.com> <20110616161803.GQ20487@llucax.com.ar>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110616161803.GQ20487@llucax.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 13:18:03 -0300, Leandro Lucarella <luca@llucax.com.ar> wrote:
> cannot access /sys/kernel/debug/dri/0/i915_error_state: No such file or directory
> 
> The debug directory is not present, should I boot or compile with some
> particular option to enable it?

You need to compile with CONFIG_DEBUGFS and at runtime
"mount -tdebugfs debug /sys/kernel/debug".

The /sys/kernel/debug/dri/0/i915_error_state will only be populated
after a hang is detected.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

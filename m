Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0I1NqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:46:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:26355 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab0I1NqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:46:23 -0400
Message-Id: <89k77n$p2kgat@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,247,1283756400"; 
   d="scan'208";a="841630045"
Date: Tue, 28 Sep 2010 14:46:19 +0100
To: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: drivers/gpu/drm/i915/i915_suspend.c:792: error: const struct intel_device_info has no member named gen
References: <AANLkTi=dqiY+kxfW4k+ke6M5J45WbM8j2Vi=y9VxYOY0@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTi=dqiY+kxfW4k+ke6M5J45WbM8j2Vi=y9VxYOY0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 21:36:09 +0800, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>   CC      drivers/gpu/drm/i915/i915_suspend.o
> drivers/gpu/drm/i915/i915_suspend.c: In function 'i915_save_state':
> drivers/gpu/drm/i915/i915_suspend.c:792: error: 'const struct
> intel_device_info' has no member named 'gen'
> drivers/gpu/drm/i915/i915_suspend.c: In function 'i915_restore_state':
> drivers/gpu/drm/i915/i915_suspend.c:827: error: 'const struct
> intel_device_info' has no member named 'gen'
> make[4]: *** [drivers/gpu/drm/i915/i915_suspend.o] Error 1
> make[3]: *** [drivers/gpu/drm/i915] Error 2
> make[2]: *** [drivers/gpu/drm] Error 2
> make[1]: *** [drivers/gpu] Error 2
> make: *** [drivers] Error 2

Which tree are you compiling? As it is missing:

commit c96c3a8cb7fadcb33d9a5ebe35fcee8b7d0a7946
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Aug 11 09:59:24 2010 +0100

    drm/i915: Include a generation number in the device info
    
    To simplify the IS_GEN[234] macros and to enable switching.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

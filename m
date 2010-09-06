Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0IFJuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:50:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:22034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0IFJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:50:01 -0400
Message-Id: <89k83a$9icvuq@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,324,1280732400"; 
   d="scan'208";a="321290202"
Date: Mon, 06 Sep 2010 10:49:56 +0100
To: Sven Joachim <svenjoac@gmx.de>
Subject: Re: [git pull] i915
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <89kc63$i063ms@fmsmga002.fm.intel.com> <8739tnw7ax.fsf@turtle.gmx.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <8739tnw7ax.fsf@turtle.gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010 11:27:34 +0200, Sven Joachim <svenjoac@gmx.de> wrote:
> Sadly, these still do not include a fix for the build failure¹ that
> occurs if CONFIG_DEBUG_FS is not set:
> 
> ,----
> |   CC [M]  drivers/gpu/drm/i915/intel_overlay.o
> | drivers/gpu/drm/i915/intel_overlay.c: In function 'intel_overlay_print_error_state':
> | drivers/gpu/drm/i915/intel_overlay.c:1467: error: implicit declaration of function 'seq_printf'
> | make[4]: *** [drivers/gpu/drm/i915/intel_overlay.o] Error 1

Andrew Morton picked up a patch to fix that, hence why I left it out.
-- 
Chris Wilson, Intel Open Source Technology Centre

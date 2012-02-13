Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2BMVuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:50:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:35558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab2BMVt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:49:59 -0500
Message-Id: <e0d58a$38gbj5@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="109588069"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Fix single msg gmbus_xfers writes
To: Daniel Vetter <daniel@ffwll.ch>, Benson Leung <bleung@chromium.org>
Cc: keithp@keithp.com, airlied@linux.ie, djkurtz@chromium.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20120213203838.GM5301@phenom.ffwll.local>
References: <1328817797-4026-1-git-send-email-bleung@chromium.org> <20120213203838.GM5301@phenom.ffwll.local>
Date: Mon, 13 Feb 2012 21:49:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 21:38:38 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> This here looks like just a white-space change. But your commit message
> sounds like it's not jsut write's that are affected by this issue and need
> to be fixed. Can you please clear up this for easily confused me?

It makes the write path similar to the read path. I admit to overlooking
the single write message as everything I saw was always a write followed
by a read. The patch looks correct, but I need to stare at it a bit more
before I r-b.

However, the outstanding issue is that we need to separate the gmbus
i2c adapter from the gpio i2c adapter in order for the pairing to work
with the expectations of the i2c core.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

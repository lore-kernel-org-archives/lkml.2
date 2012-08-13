Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2HMRFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:05:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55744 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2HMRE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:04:58 -0400
Date: Mon, 13 Aug 2012 19:05:17 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@intel.com>
Cc: ionic@ionic.de, daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/i915: ensure i2c adapter is all set before
 adding it
Message-ID: <20120813170517.GE5248@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@intel.com>, ionic@ionic.de,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <cover.1344867962.git.jani.nikula@intel.com>
 <b6dc8317cdc108b22f90453b3d6f7475a620d96c.1344867962.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6dc8317cdc108b22f90453b3d6f7475a620d96c.1344867962.git.jani.nikula@intel.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 05:33:02PM +0300, Jani Nikula wrote:
> i2c_add_adapter() may do i2c transfers on the bus to detect supported
> devices. Therefore the adapter needs to be all set before adding it. This
> was not the case for the bit-banging fallback, resulting in an oops if the
> device detection GMBUS transfers timed out. Fix the issue by calling
> i2c_add_adapter() only after intel_gpio_setup().
> 
> LKML-Reference: <5021F00B.7000503@ionic.de>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Applied to -fixes with Mihai's tested-by added, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

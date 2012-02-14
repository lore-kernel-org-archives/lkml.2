Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab2BNJrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:47:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51508 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2BNJre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:47:34 -0500
Date: Tue, 14 Feb 2012 10:47:43 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Yufeng Shen <miletus@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Ben Widawsky <ben@bwidawsk.net>
Subject: Re: [PATCH] drm/i915: Fix race condition in accessing GMBUS
Message-ID: <20120214094743.GB4097@phenom.ffwll.local>
Mail-Followup-To: Yufeng Shen <miletus@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Eugeni Dodonov <eugeni.dodonov@intel.com>,
	Ben Widawsky <ben@bwidawsk.net>
References: <1328825697-23685-1-git-send-email-miletus@chromium.org>
 <1329172614-13085-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329172614-13085-1-git-send-email-miletus@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 05:36:54PM -0500, Yufeng Shen wrote:
> Moved gmbus_mutex below intel_gmbus and added comments.
> Rebased to drm-intel-next-queued.
> 
> ----------------------------------------------------------------
> 
> GMBUS has several ports and each has it's own corresponding
> I2C adpater. When multiple I2C adapters call gmbus_xfer() at
> the same time there is a race condition in using the underlying
> GMBUS controller. Fixing this by adding a mutex lock when calling
> gmbus_xfer().
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>

Queued for -next (with some slight modifications in the comments), thanks
for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

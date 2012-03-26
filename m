Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2CZPJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:09:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47275 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2CZPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:09:50 -0400
Date: Mon, 26 Mar 2012 17:10:33 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 04/11 v3] drm/i915/intel_i2c: cleanup gmbus/gpio pin
 assignments
Message-ID: <20120326151033.GR4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-5-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
In-Reply-To: <1332772010-19619-5-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:26:43PM +0800, Daniel Kurtz wrote:
> There is no GMBUS "disabled" port 0, nor "reserved" port 7.
> For the other 6 ports there is a fixed 1:1 mapping between pin pairs and
> gmbus ports, which means every real gmbus port has a gpio pin.
> 
> Given these realizations, clean up gmbus initialization.
> 
> Tested on Sandybridge (gen 6, PCH == CougarPoint) hardware.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Nice cleanup.
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

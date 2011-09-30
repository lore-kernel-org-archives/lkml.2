Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1I3Ro3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:44:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45370 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1I3Ro1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:44:27 -0400
Date: Fri, 30 Sep 2011 19:45:02 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 12/21] drm/i915: Ensure eDP powered up during
 DP_SET_POWER operation in dp_prepare
Message-ID: <20110930174502.GL2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-13-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-13-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:44PM -0700, Keith Packard wrote:
> Any call to intel_dp_sink_dpms must ensure that the panel has power so
> that the DP_SET_POWER operation will be correctly received. The only
> one missing this was in intel_dp_prepare.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
If I understand things correctly we don't need the vdd_on/off on dpms off
because the panel is running and has power. Assuming my understanding is
correct:
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

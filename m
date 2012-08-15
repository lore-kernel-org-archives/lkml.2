Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2HOWmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:42:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50305 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2HOWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:42:11 -0400
Date: Thu, 16 Aug 2012 00:42:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/7] drm/i915: Allow VGA on CRTC 2
Message-ID: <20120815224232.GE5533@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
 <1344918891-6283-2-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344918891-6283-2-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 09:34:45PM -0700, Keith Packard wrote:
> This is left over from the old PLL sharing code and isn't useful now
> that PLLs are shared when possible.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Queued for -next, thanks for the patch. I'll hold off a bit on the others
until it's a bit clearer what's going on/wrong.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

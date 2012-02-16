Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2BPJ6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:58:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61333 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2BPJ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:58:19 -0500
Date: Thu, 16 Feb 2012 10:58:27 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Keith Packard <keithp@keithp.com>, Danny Kukawka <dkukawka@suse.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "drivers/gpu/drm/i915/intel_overlay.c needs
 seq_file.h"
Message-ID: <20120216095827.GA4048@phenom.ffwll.local>
Mail-Followup-To: Danny Kukawka <danny.kukawka@bisect.de>,
	Keith Packard <keithp@keithp.com>, Danny Kukawka <dkukawka@suse.de>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1329328435-4569-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329328435-4569-1-git-send-email-danny.kukawka@bisect.de>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 06:53:55PM +0100, Danny Kukawka wrote:
> This reverts commit e167976ee7f5fe4b80f7e8f55e087f6c67cf9562,
> Since this was already fixed in commit
> 3bd3c9329973a93fa3ef5e9840f2fd6fa2889e3f some days before this
> commit cause seq_file.h to be included twice.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1JONsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:48:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45337 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1JONsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:48:31 -0400
Date: Sat, 15 Oct 2011 15:49:10 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 11/12] i915:  Move i915_read/write out of line
Message-ID: <20111015134909.GA2819@phenom.ffwll.local>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Andi Kleen <ak@linux.intel.com>, dri-devel@lists.freedesktop.org
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
 <1318547332-23155-11-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318547332-23155-11-git-send-email-andi@firstfloor.org>
X-Operating-System: Linux phenom 3.0.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 04:08:51PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> With the tracing code in there they are far too big to inline.
> 
> .text savings compared to a non force inline kernel:
> 
> i915_restore_display                        4393   12036   +7643
> i915_save_display                           4295   11459   +7164
> i915_handle_error                           2979    6666   +3687
> i915_driver_irq_handler                     2923    5086   +2163
> i915_ringbuffer_info                         458    1661   +1203
> i915_save_vga                                  -    1200   +1200
> i915_driver_irq_uninstall                    453    1624   +1171
> i915_driver_irq_postinstall                  913    2078   +1165
> ironlake_enable_drps                         719    1872   +1153
> i915_restore_vga                               -    1142   +1142
> intel_display_capture_error_state            784    2030   +1246
> intel_init_emon                              719    2016   +1297
> 
> and more ...
> 
> [AK: these are older numbers, with the new SNB forcewake checks
> it will be even worse]
> 
> Cc: keithp@keithp.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

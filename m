Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2HPOep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:34:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49484 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2HPOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:34:42 -0400
Date: Thu, 16 Aug 2012 16:35:03 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@intel.com>
Cc: maciej.rutecki@gmail.com, alferpal@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        daniel@ffwll.ch
Subject: Re: [PATCH 2/2] drm/i915: fall back to bit-banging if GMBUS fails in
 CRT EDID reads
Message-ID: <20120816143503.GC5083@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@intel.com>,
	maciej.rutecki@gmail.com, alferpal@gmail.com,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org
References: <cover.1344852255.git.jani.nikula@intel.com>
 <03e17075b1252d819178316c8b2a12573e59ddca.1344852255.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03e17075b1252d819178316c8b2a12573e59ddca.1344852255.git.jani.nikula@intel.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 01:22:35PM +0300, Jani Nikula wrote:
> GMBUS was enabled over bit-banging as the default in commits:
> 
> commit c3dfefa0a6d235bd465309e12f4c56ea16e71111
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Tue Feb 14 22:37:25 2012 +0100
> 
>     drm/i915: reenable gmbus on gen3+ again
> 
> and
> 
> commit 0fb3f969c8683505fb7323c06bf8a999a5a45a15
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Fri Mar 2 19:38:30 2012 +0100
> 
>     drm/i915: enable gmbus on gen2
> 
> Unfortunately, GMBUS seems to fail on some CRT displays. Add a bit-banging
> fallback to CRT EDID reads.
> 
> LKML-Reference: <201207251020.47637.maciej.rutecki@gmail.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45881
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Patches applied to -fixes with the tested-by result from the bug report.
I've also put a cc: stable on both of them, since the regression is
already in 3.4.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

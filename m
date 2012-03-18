Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2CRS7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 14:59:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37053 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2CRS7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 14:59:53 -0400
Date: Sun, 18 Mar 2012 20:00:34 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Menzel <paulepanter@users.sourceforge.net>
Subject: Re: [V5 PATCH 0/4] Provide workarounds to use DRM/KMS with broken
 graphics hardware
Message-ID: <20120318190034.GI4286@phenom.ffwll.local>
Mail-Followup-To: Carsten Emde <C.Emde@osadl.org>,
	David Airlie <airlied@linux.ie>,
	Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paul Menzel <paulepanter@users.sourceforge.net>
References: <20120315145623.486070468@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315145623.486070468@osadl.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 03:56:23PM +0100, Carsten Emde wrote:
> Changes from V4 to V5:
> 
> 1. Split the previous patch 2/2 into three patches to separately i) add the
> module parameter, ii) add the quirk infrastructure, and iii) actually quirk
> the related machine.
> 
> 2. Rename the module parameter variable to i915_panel_invert_brightness.
> 
> 3. Make the module parameter variable tristate to either ignore the
> quirk, consider the quirk, if any, or force inversion.
> 
> 4. Print an instruction along the description of the module parameter to
> encourage people sending machine data, should another machine be found
> that needs to be quirked.
> 
> 5. Introduce the function intel_panel_compute_brightness where the
> brightness calculation is handled.
> 
> Thanks, Chris, for these very valuable suggestions.

I've picked up patches 2-4 from this series, thanks.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

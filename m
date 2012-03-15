Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275Ab2COPPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:15:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:32378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2COPPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:15:12 -0400
Message-Id: <aefc95$3ggeaf@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117979471"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [V5 PATCH 2/4] drivers-gpu-drm-i915-panel-invert-brightness-via-parameter.patch
To: Carsten Emde <C.Emde@osadl.org>, David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120315145828.308069018@osadl.org>
References: <20120315145623.486070468@osadl.org> <20120315145828.308069018@osadl.org>
Date: Thu, 15 Mar 2012 15:15:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 15:56:25 +0100, Carsten Emde <C.Emde@osadl.org> wrote:
> Following the documentation of the Legacy Backlight Brightness (LBB)
> Register in the configuration space of some Intel PCI graphics adapters,
> setting the LBB register with the value 0x0 causes the backlight to be
> turned off, and 0xFF causes the backlight to be set to 100% intensity
> (http://download.intel.com/embedded/processors/Whitepaper/324567.pdf).
> The Acer Aspire 5734Z, however, turns the backlight off at 0xFF and sets
> it to maximum intensity at 0. In consequence, the screen of this systems
> becomes dark at an early boot stage which makes it unusable. The same
> inversion applies to the BLC_PWM_CTL I915 register. This problem was
> introduced in kernel version 2.6.38 when the PCI device of this system
> was first supported by the i915 KMS module.
> 
> This patch adds a parameter to the i915 module to enable inversion of
> the brightness variable (i915.invert_brightness).
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

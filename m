Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669Ab2COPPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:15:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:64513 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab2COPPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:15:46 -0400
Message-Id: <e39f63$44thoj@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139380499"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [V5 PATCH 3/4] drivers-gpu-drm-i915-panel-invert-brightness-via-quirk.patch
To: Carsten Emde <C.Emde@osadl.org>, David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120315145828.898778929@osadl.org>
References: <20120315145623.486070468@osadl.org> <20120315145828.898778929@osadl.org>
Date: Thu, 15 Mar 2012 15:15:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 15:56:26 +0100, Carsten Emde <C.Emde@osadl.org> wrote:
> A machine may need to invert the panel backlight brightness value. This
> patch adds the infrastructure for a quirk to do so.
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

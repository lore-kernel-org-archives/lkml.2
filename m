Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394Ab2COPRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:17:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:51469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965133Ab2COPRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:17:18 -0400
Message-Id: <aefc95$3ggehm@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117979702"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [V5 PATCH 4/4] drivers-gpu-drm-i915-panel-invert-brightness-acer-aspire-5734z.patch
To: Carsten Emde <C.Emde@osadl.org>, David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120315145829.555961411@osadl.org>
References: <20120315145623.486070468@osadl.org> <20120315145829.555961411@osadl.org>
Date: Thu, 15 Mar 2012 15:16:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 15:56:27 +0100, Carsten Emde <C.Emde@osadl.org> wrote:
> Mark the Acer Aspire 5734Z that this machines requires the module to
> invert the panel backlight brightness value after reading from and prior
> to writing to the PCI configuration space.
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

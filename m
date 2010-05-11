Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0EKTxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:53:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:15655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab0EKTxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:53:52 -0400
Message-Id: <89khjo$fd2th6@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,209,1272870000"; 
   d="scan'208";a="517043750"
Date: Tue, 11 May 2010 20:53:46 +0100
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <0100511104818.8382a7de.akpm@linux-foundation.org> <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com> <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 01:08:23 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> Hello Chris and Andrew,
> 
> I did further testing and noticed that this patch fixes the boot
> errors and warnings and I get the XWindows.
> 
> But XWindows freezes after some time.

The BUG you were hitting before is on the error collection path which
presumably is still being triggered during boot by a GPU error.
Can you check to see if /sys/kernel/debug/dri/0/i915_error_state has
recorded anything? And if not, wait until it freezes and then please file
a bug report at bugs.freedesktop.org with the i915_error_state, Xorg.0.log
and dmesg.

-- 
Chris Wilson, Intel Open Source Technology Centre

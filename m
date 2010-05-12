Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0ELNu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:50:56 -0400
Received: from mga12.intel.com ([143.182.124.36]:26689 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752089Ab0ELNuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:50:55 -0400
Message-Id: <89k83a$87e1b2@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,215,1272870000"; 
   d="scan'208";a="276235618"
Date: Wed, 12 May 2010 14:50:50 +0100
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <0100511104818.8382a7de.akpm@linux-foundation.org> <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com> <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com> <89khjo$fd2th6@orsmga002.jf.intel.com> <AANLkTilbqi5crUD8KXmZ5SIv92KioEAN7Ra6nk2ALU6F@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTilbqi5crUD8KXmZ5SIv92KioEAN7Ra6nk2ALU6F@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 18:45:55 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> Hello Chris,
> 
> With this patch after XWindows freezes, I get :
[snip]
> freeze dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634_chris_hang.txt
> 
> freeze Xorg.log : http://userweb.kernel.org/~jaswinder/acer_netbook/Xorg_log.txt

Jaswinder can you also upload the /sys/kernel/debug/dri/0/i915_error_state
following a freeze as well, please. If your /sys/kernel/debug is empty,
you will need to "mount -tdebugfs debug /sys/kernel/debug".

> So it means this patches shifted the BUG and warning messages after
> some time. So I can only work on XWindows for few minutes with this
> patch.
> Andrew patch is in linus git tree. Can you please update your patch
> above Andrew patch. So that I can do further testing.

What is in the tree is adequate for the time being. It will capture the
batch buffer into the error state. My follow-on patch only increases the
level of paranoia. Thanks for testing.

-- 
Chris Wilson, Intel Open Source Technology Centre

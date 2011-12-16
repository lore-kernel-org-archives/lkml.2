Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab1LPQjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:39:07 -0500
Received: from eazy.amigager.de ([213.239.192.238]:52251 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab1LPQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:38:48 -0500
Date: Fri, 16 Dec 2011 17:38:39 +0100
From: tino.keitel+xorg@tikei.de
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rocko Requin <rockorequin@hotmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at drivers/gpu/drm/i915/i915_gem
Message-ID: <20111216163839.GA7884@x61.home>
Mail-Followup-To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rocko Requin <rockorequin@hotmail.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl>
 <CAKMK7uEm8=bGWxDSbLtOEM3CBmbMSH+gWrUy0Od327ozvjOd5g@mail.gmail.com>
 <BAY151-W537E90462ED274C21FDA4CA1BE0@phx.gbl>
 <CAKMK7uH-_VzaeTsNJYL_wMfUHqMkvG-BSCxicfQ--RQ-_O5jsg@mail.gmail.com>
 <BAY151-W53C3AD24F2938042D0F733A1BC0@phx.gbl>
 <CAKMK7uGpn6AJGtbMCYWW1ziR=Zs+E9LB=aiB5aUu0unfVW=2oA@mail.gmail.com>
 <20111214195751.GA31690@mac.home>
 <20111215185415.GA3445@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215185415.GA3445@mac.home>
X-TUID: 63908040282d363f
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 19:54:15 +0100, tino.keitel+xorg@tikei.de wrote:
> On Wed, Dec 14, 2011 at 20:57:51 +0100, tino.keitel+xorg@tikei.de wrote:
> 
> [...]
> 
> > it looks I stumbled over the same:
> > 
> > [88399.844150] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1952!
> > 2011-12-14_19:28:56.93083 <0>[88399.844182] invalid opcode: 0000 [#1]
> > SMP 
> > 
> > While doing this I was running a 32 bit photo software (Bibble 5 pro)
> > in fullscreen on an otherwise 64 bit system.
> > 
> > The full log including the trace is attached.
> > 
> > I'll try with the patch applied.
> 
> I just got the same hang again with the patch applied.

Hum, could this be related to the RC6 vs. IOMMU issue? I have
CONFIG_INTEL_IOMMU enabled in 3.2, and disabled in 3.1, and boot with
i915.i915_enable_rc6=1.

Regards,
Tino

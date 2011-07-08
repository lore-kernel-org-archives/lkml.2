Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1GHOuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:50:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1GHOuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:50:10 -0400
Date: Fri, 8 Jul 2011 07:45:17 -0700
From: Greg KH <gregkh@suse.de>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel J Blueman <daniel.blueman@gmail.com>,
        Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Subject: Re: [026/107] drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.
Message-ID: <20110708144517.GD22691@suse.de>
References: <20110708001655.280182108@clark.kroah.org>
 <yun4o2xti42.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun4o2xti42.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 11:13:33PM -0700, Keith Packard wrote:
> On Thu, 07 Jul 2011 17:15:58 -0700, Greg KH <gregkh@suse.de> wrote:
> 
> > 2.6.39-stable review patch.  If anyone has any objections, please let
> > us know.
> 
> Note that there's a follow-on patch to this which fixes similar hangs
> with the BSD ring:
> 
> ec6a890dfed7dd245beba5e5bcdfcffbd934c284
> 
>     drm/i915: Apply HWSTAM workaround for BSD ring on SandyBridge
>     
>     ...we need to apply exactly the same workaround for missing interrupts
>     from BSD as for the BLT ring, apparently.
>     
>     See also commit 498e720b96379d8ee9c294950a01534a73defcf3
>     (drm/i915: Fix gen6 (SNB) missed BLT ring interrupts).
>     
>     Reported-and-tested-by: nkalkhof@web.de
>     Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38529
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Signed-off-by: Keith Packard <keithp@keithp.com>

Thanks, I've queued that one up now as well.

greg k-h

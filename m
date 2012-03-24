Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2CXTVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 15:21:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45294 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2CXTVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 15:21:09 -0400
Date: Sat, 24 Mar 2012 20:21:48 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm main pull for 3.4-rc1
Message-ID: <20120324192148.GA18786@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@linux.ie>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
	DRI mailing list <dri-devel@lists.freedesktop.org>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
 <CA+55aFzHEuXoejUSTgXbzr4m4t-C+r0HBRCmB0RuCiW-ndQv1g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+55aFzHEuXoejUSTgXbzr4m4t-C+r0HBRCmB0RuCiW-ndQv1g@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 12:15:27PM -0700, Linus Torvalds wrote:
> Btw, I think this came in through the DRM merge:
> 
>   ERROR: "mdfld_set_brightness" [drivers/gpu/drm/gma500/gma500_gfx.ko]
> undefined!
>   make[1]: *** [__modpost] Error 1
>   make: *** [modules] Error 2
> 
> this is just "make ARCH=i386" with allmodconfig.

Message-Id: <1332540112-469-1-git-send-email-kirill.shutemov@linux.intel.com>

... on lkml (cross-posted to dri-devel, too) looks like the patch you want.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

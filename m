Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1IPOak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:30:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39066 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1IPOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:30:39 -0400
Date: Fri, 16 Sep 2011 16:31:04 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: airlied@gmail.com, Akshay Joshi <me@akshayjoshi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Whitespace cleanups in drm/i915
Message-ID: <20110916143104.GE2873@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>, airlied@gmail.com,
	Akshay Joshi <me@akshayjoshi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <yun8vppw9lu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun8vppw9lu.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 06:37:33PM -0700, Keith Packard wrote:
> I've got this nice patch from Akshay Joshi that removes almost all of
> the checkpatch.pl warnings from drm/i915. If I don't merge it now, it's
> going to go stale and be useless; if I merge it only to drm-intel-next,
> it will be the source of endless conflicts.
> 
> However, it's a huge patch (yes, the code was rather sloppy), and
> doesn't exactly fit into the "critical patches only please" mode of the
> current stage of 3.1 development.
> 
> I've checked the patch very carefully, using the obvious git diff -b to
> make sure it really doesn't touch anything but whitespace, but also
> using objdump -s to compare the output of the compiler. There were no
> differences found with git-diff -b. The only differences found by
> objdump are two whitespace changes in some debug output messages in
> intel_bios.c.
> 
> I think I have three choices:
> 
>  1) merge the patch and expect complaints from upstream
> 
>  2) thank Akshay for his good intentions, discard the patch and hope
>     that he feels motivated enough to do it all over again in time for
>     the 3.2 merge window.
> 
>  3) thank Akshay for his good intentions and leave the code as-is,
>     forever to ease back-porting of fixes to older kernel versions.
> 
> Frankly, if we're ever going to merge whitespace fixups, this would be a
> pretty darn good time; drm-intel-fixes and drm-intel-next are in-sync as
> I haven't started pulling 3.2 code into -next.

Well, I've just started to build up patches, so my current queue is tiny
;-)

Otoh massive whitespace changes always annoy when backporting fixes and
also when moving forward work-in-progress and old proof-of-concept
patches. If you think it's really worth it, go for it. Otherwise I think
strictly enforcing checkpatch compliance (and sparse-cleanliness, while
we're at it) going forward should get us there pretty quickly (we have
some code-churn after all). And then we could fix up the remaining code in
1-2 releases or so - by then that patch should only touch code that's in
maintaince mode for older hw, hopefully.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

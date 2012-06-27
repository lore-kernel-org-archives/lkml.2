Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2F0Sk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:40:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38098 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2F0Sky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:40:54 -0400
Date: Wed, 27 Jun 2012 20:40:50 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [daniel@ffwll.ch: [pull] drm-intel-fixes]
Message-ID: <20120627184050.GJ5326@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm so ridiculously good at forgetting about the cc's on these pull
requests ...
-Daniel

----- Forwarded message from Daniel Vetter <daniel@ffwll.ch> -----

Date: Wed, 27 Jun 2012 20:39:43 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Subject: [pull] drm-intel-fixes
Message-ID: <20120627183943.GI5326@phenom.ffwll.local>

Hi Dave,

Two tiny patches and one revert:
- Kill a bogus error message introduced in 3.4, further Bspec reading
  indicates that this is how the hw is supposed to work.
- Reorder one backlight register restore, fixing broken backlight on some
  machines after resume.
- Revert a hack from Jesse for ivb backlight control - it breaks the
  backlight controls on my shiny new ivb laptop.

Otherwise I'm only aware of 1-2 regression reports about new modes that
don't work - but it looks like Ajax is already picking up the fallout on
that one.

Yours, Daniel

The following changes since commit 8874e812feb4926f4a51a82c4fca75c7daa05fc5:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs (2012-06-21 13:41:07 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 7aa1e7f06d6ea1bce3b27630d50769d13da28b1a:

  Revert "drm/i915: allow PCH PWM override on IVB" (2012-06-27 20:26:30 +0200)

----------------------------------------------------------------
Daniel Vetter (2):
      drm/i915: rip out the PM_IIR WARN
      Revert "drm/i915: allow PCH PWM override on IVB"

Takashi Iwai (1):
      drm/i915: Fix eDP blank screen after S3 resume on HP desktops

 drivers/gpu/drm/i915/i915_irq.c      |    1 -
 drivers/gpu/drm/i915/i915_suspend.c  |    5 ++++-
 drivers/gpu/drm/i915/intel_display.c |   16 ----------------
 3 files changed, 4 insertions(+), 18 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

----- End forwarded message -----

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

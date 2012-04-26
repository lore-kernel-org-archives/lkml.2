Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2DZPeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:34:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47223 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab2DZPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:34:03 -0400
Date: Thu, 26 Apr 2012 17:35:01 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: [pull] drm-intel-fixes for 3.4
Message-ID: <20120426153501.GC5156@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Nothing major here and imo can wait a bit if you don't have anything
important in drm-fixes yet:
- VGA load-detect fix. This bug seems to be as old as the load-detect code
  (2.6.30), but needs stupid userspace (upowerd trying to detect
  connectors on dpms-off outputs) to actually kill the machine. And
  obviously a machine without VGA-hotplug, otherwise we don't do load
  detect.
- 2 interger overflow fixes for unpriviledged ioctls from Xi Wang.

Yours, Daniel

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 44afb3a04391a74309d16180d1e4f8386fdfa745:

  drm/i915: fix integer overflow in i915_gem_do_execbuffer() (2012-04-23 22:32:15 +0200)

----------------------------------------------------------------
Daniel Vetter (1):
      drm/i915: fixup load-detect on enabled, but not active pipe

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()

 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    8 +++++++-
 drivers/gpu/drm/i915/intel_crt.c           |   29 +++++++++++-----------------
 2 files changed, 18 insertions(+), 19 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2EGImy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:42:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38814 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2EGImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:42:53 -0400
Date: Mon, 7 May 2012 10:43:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-fixes
Message-ID: <20120507084355.GA5001@phenom.ffwll.local>
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

Hi Dave,

2 little patches:
- One regression fix to disable sdvo hotplug on broken hw.
- One patch to upconvert the snb hang workaround from patch v1 to patch
  v2.

Yours, Daniel

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to 2e7a44814d802c8ba479164b8924070cd908d6b5:

  drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+ (2012-05-07 10:37:56 +0200)

----------------------------------------------------------------
Daniel Vetter (2):
      drm/i915: disable sdvo hotplug on i945g/gm
      drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+

 drivers/gpu/drm/i915/intel_ringbuffer.c |    9 ++++++---
 drivers/gpu/drm/i915/intel_sdvo.c       |    6 ++++++
 2 files changed, 12 insertions(+), 3 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

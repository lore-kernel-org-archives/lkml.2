Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2JLXtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 19:49:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2JLXtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 19:49:40 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, backports@vger.kernel.org, rob@ti.com,
        arnd@arndb.de, davej@redhat.com, airlied@linux.ie, bskeggs@redhat.com,
        alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, tglx@linutronix.de,
        daniel.vetter@ffwll.ch, jbarnes@virtuousgeek.org,
        alexander.deucher@amd.com, paulmck@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/2] uapi: two minor changes
Date: Fri, 12 Oct 2012 16:49:30 -0700
Message-Id: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Here are a few minor updates to the UAPI changes [0]. The first
one is to help with the backport effort [1], the second one is
simply space cosmetic change to address my eyes bleeding
while reviewing the changes on next-20121012 with git.

If the changes on the first patch make sense perhaps similar
changes can be done for the other subsystem in similar cases.
In those cases the now kernel API header file no longer exists
so even if userspace were using the files the only way to pick
the header up would have been to provide the new uapi path.

[0] http://lwn.net/Articles/507794/
[1] https://backports.wiki.kernel.org

Luis R. Rodriguez (2):
  uapi: update includes for drm content when no kernel API exists
  uapi: remove trailing spaces

 drivers/gpu/drm/drm_crtc.c            |    2 +-
 drivers/gpu/drm/nouveau/nv04_cursor.c |    2 +-
 drivers/staging/omapdrm/omap_crtc.c   |    2 +-
 include/drm/drmP.h                    |    4 ++--
 include/drm/drm_crtc.h                |    4 ++--
 include/uapi/asm-generic/siginfo.h    |    4 ++--
 include/uapi/asm-generic/statfs.h     |    4 ++--
 include/uapi/drm/drm.h                |    2 +-
 include/uapi/drm/radeon_drm.h         |    2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.7.10.4


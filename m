Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0KXGgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:36:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1844 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0KXGgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:36:44 -0500
Subject: [PATCH] MAINTAINERS: INTEL DRM DRIVERS list (intel-gfx) is
 subscribers-only
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 22:36:42 -0800
Message-ID: <1290580602.11971.44.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark it so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ac6540..07aa850 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2080,7 +2080,7 @@ F:	include/drm/
 
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Chris Wilson <chris@chris-wilson.co.uk>
-L:	intel-gfx@lists.freedesktop.org
+L:	intel-gfx@lists.freedesktop.org (subscribers-only)
 L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git
 S:	Supported



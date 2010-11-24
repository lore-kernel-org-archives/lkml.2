Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0KXWEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:04:55 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:14239 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0KXWEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:04:54 -0500
Date: Wed, 24 Nov 2010 17:04:53 -0500
Message-Id: <201011242204.oAOM4rvH011564@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile fixes for v2.6.37
X-OriginalArrivalTime: 24 Nov 2010 22:04:53.0777 (UTC) FILETIME=[9F7E0010:01CB8C23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 2.6.37 from

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

This fixes three tile-specific bug fixes that have been uncovered in
the last few weeks of testing.

Chris Metcalf (3):
      arch/tile: fix rwlock so would-be write lockers don't block new readers
      arch/tile: make glibc's sysconf(_SC_NPROCESSORS_CONF) work correctly
      arch/tile: fix memchr() not to dereference memory for zero length

 arch/tile/kernel/setup.c    |    2 +-
 arch/tile/lib/memchr_32.c   |   35 +++++++++++++++++++----------------
 arch/tile/lib/spinlock_32.c |   29 ++++++++++++++++++-----------

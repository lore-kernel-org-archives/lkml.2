Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab1E3OvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:51:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:57874 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab1E3Ou7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:50:59 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Fixes for X.Y kernel versions
Date: Mon, 30 May 2011 16:50:48 +0200
Message-Id: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are a couple of fixes to allow to name the kernel 3.0. The depmod
hack is not anything I am proud of, but it worked for me :). The rest
are no-brainers.

Michal

Michal Marek (4):
  kbuild: Fix KERNELVERSION for X.Y versions
  kbuild: Fix <linux/version.h> for X.Y versions
  perf: Use make kernelversion instead of parsing the Makefile
  kbuild: Hack for depmod not handling X.Y versions

 Makefile                         |   16 +++++++++++++---
 tools/perf/util/PERF-VERSION-GEN |    7 +------
 2 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.7.4.1


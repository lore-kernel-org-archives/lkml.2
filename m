Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab0LTQQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:16:00 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36984 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab0LTQPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:15:54 -0500
Date: Tue, 21 Dec 2010 01:14:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.37-rc7
Message-ID: <20101220161424.GA30652@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-fixes-for-linus

Which contains:

Magnus Damm (2):
      ARM: mach-shmobile: fix compile warning in mm/init.c
      ARM: mach-shmobile: INTC interrupt priority level demux fix

 arch/arm/mach-shmobile/include/mach/entry-macro.S |   30 ++++++++++++++++++---
 arch/arm/mach-shmobile/include/mach/vmalloc.h     |    2 +-
 2 files changed, 27 insertions(+), 5 deletions(-)

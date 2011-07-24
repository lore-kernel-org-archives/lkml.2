Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1GXJqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:46:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:45981 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1GXJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:46:10 -0400
Message-Id: <20110723212603.517924252@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 24 Jul 2011 09:46:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>
Subject: [patch 0/3] x86: cache_info: Bugfix and cleanups AMD_NB related
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a kfree() problem in the cache_info code
and cleans up the shadow struct mess and gets rid of the atomic
allocation in the smp function call.

Thanks,

	tglx
---
 include/asm/amd_nb.h         |    6 ++
 kernel/cpu/intel_cacheinfo.c |  121 ++++++++++++++-----------------------------
 2 files changed, 47 insertions(+), 80 deletions(-)



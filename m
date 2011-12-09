Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1LISJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:09:16 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36268 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1LISJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:08 -0500
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/5] x86, microcode, AMD: Update copyrights
Date: Fri,  9 Dec 2011 19:08:55 +0100
Message-Id: <1323454135-16777-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323454135-16777-1-git-send-email-bp@amd64.org>
References: <1323454135-16777-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add Andreas and me as current maintainers.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index d80e943..fe86493 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -1,14 +1,18 @@
 /*
  *  AMD CPU Microcode Update Driver for Linux
- *  Copyright (C) 2008 Advanced Micro Devices Inc.
+ *  Copyright (C) 2008-2011 Advanced Micro Devices Inc.
  *
  *  Author: Peter Oruba <peter.oruba@amd.com>
  *
  *  Based on work by:
  *  Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
  *
- *  This driver allows to upgrade microcode on AMD
- *  family 0x10 and 0x11 processors.
+ *  Maintainers:
+ *  Andreas Herrmann <andreas.herrmann3@amd.com>
+ *  Borislav Petkov <borislav.petkov@amd.com>
+ *
+ *  This driver allows to upgrade microcode on F10h AMD
+ *  CPUs and later.
  *
  *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
-- 
1.7.8.rc0


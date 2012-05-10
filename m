Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab2EJOb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:31:28 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56058 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab2EJOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 9/9] x86, MCE, AMD: Update copyrights and boilerplate
Date: Thu, 10 May 2012 16:30:29 +0200
Message-Id: <1336660229-32644-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Jacob is doing something else now so add myself as the loser who
provides support.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index e20bdf8d7c59..671b95a2ffb5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -1,15 +1,17 @@
 /*
- *  (c) 2005, 2006 Advanced Micro Devices, Inc.
+ *  (c) 2005-2012 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
  *  GNU general public license version 2. See "COPYING" or
  *  http://www.gnu.org/licenses/gpl.html
  *
  *  Written by Jacob Shin - AMD, Inc.
  *
- *  Support : jacob.shin@amd.com
+ *  Support: borislav.petkov@amd.com
  *
  *  April 2006
  *     - added support for AMD Family 0x10 processors
+ *  May 2012
+ *     - major scrubbing
  *
  *  All MC4_MISCi registers are shared between multi-cores
  */
-- 
1.7.9.3.362.g71319


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0H1QGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:06:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44080 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0H1QGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Cy1DuPSSMBW5YHe93Jj1wkFtRzB4Oxb/FZALgR2X7PEFz30SWvTNewXcPXVSOgeiGj
         5MUrAIOv9GCq7kRrs9m0Dewq45fA3Oq1svwqf8vFaC13ZS8Mx9GlB7nmZ0uiEIi7tMlA
         +u2Vumn9NAYAtAWlu/A2+zB9vxL8sLIMpZjCc=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: x86: FPU cleanups
Date: Sat, 28 Aug 2010 12:04:27 -0400
Message-Id: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/11] x86: Use correct type for %cr4
[PATCH 02/11] x86: Merge fpu_init()
[PATCH 03/11] x86: Merge tolerant_fwait()
[PATCH 04/11] x86: Merge __save_init_fpu()
[PATCH 05/11] x86-64: Disable preemption when using TS_USEDFPU
[PATCH 06/11] x86-64: Fix %cs value in convert_from_fxsr()
[PATCH 07/11] x86-64: Simplify constraints for fxsave/fxtstor
[PATCH 08/11] x86-32: Remove math_emulate stub
[PATCH 09/11] x86: Merge fpu_save_init()
[PATCH 10/11] x86: Remove unnecessary ifdefs from i387 code.
[PATCH 11/11] x86: Remove PSHUFB_XMM5_* macros

 arch/x86/include/asm/i387.h      |  188 ++++++++++----------------------------
 arch/x86/include/asm/processor.h |    4 +-
 arch/x86/kernel/cpu/common.c     |    7 --
 arch/x86/kernel/i387.c           |   49 ++++------
 arch/x86/kernel/process_64.c     |    2 +-
 arch/x86/kernel/traps.c          |   35 +------
 6 files changed, 78 insertions(+), 207 deletions(-)


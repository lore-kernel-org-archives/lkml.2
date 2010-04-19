Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0DSVxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:53:23 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:55064 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0DSVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:53:22 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 0/5] uml: Some trivial cleanups
Date: Mon, 19 Apr 2010 23:53:03 +0200
Message-Id: <cover.1271713955.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
X-Provags-ID: V01U2FsdGVkX1/d0BQ/embpeVQkzSvvXLCO2tZSDC2gX3tP/6+q
	q/VO4Xa/igLJNNeVGzujV2LU8JWZ+9m09logret5H38yHu4/Bm
	oTFJ2k+4E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some trivial build warning fixes and cleanups for UML.

Jan Kiszka (5):
  uml: Remove unused variable from line driver
  uml: Drop private round_down definition
  uml: Fix warning due to missing task_struct declaration
  uml: i386: Avoid redefinition of NR_syscalls
  uml: Clean up asm/system.h

 arch/um/drivers/line.c        |    1 -
 arch/um/include/asm/system.h  |    3 ---
 arch/um/kernel/skas/syscall.c |    4 ++--
 arch/um/sys-i386/asm/elf.h    |    2 ++
 arch/um/sys-x86_64/asm/elf.h  |    2 ++
 arch/um/sys-x86_64/signal.c   |    2 --
 6 files changed, 6 insertions(+), 8 deletions(-)


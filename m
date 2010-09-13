Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0IMUOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:14:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:39660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0IMUOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="656856225"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 0/5] Bump gcc minimum version to 3.4, 4.1 for x86
Date: Mon, 13 Sep 2010 13:14:35 -0700
Message-Id: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset bumps the minimum supported gcc version to 3.4 for the
general kernel, and to 4.1 for x86.

We have had a rash of bug reports related to these really old
compilers and their associated binutils version lately, and it is
clear that the support burden of these older compilers is getting to
be excessive.  If you really want to build a kernel on a system that
old you can build or obtain an updated gcc/binutils as well.

 Documentation/Changes             |    2 +-
 arch/x86/include/asm/bitops.h     |    7 -------
 arch/x86/include/asm/cpufeature.h |    7 -------
 arch/x86/include/asm/string_32.h  |   21 ---------------------
 arch/x86/kernel/Makefile          |    3 ++-
 arch/x86/kernel/compiler.c        |    5 +++++
 include/linux/compiler-gcc3.h     |   15 +--------------
 7 files changed, 9 insertions(+), 51 deletions(-)

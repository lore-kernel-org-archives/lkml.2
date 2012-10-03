Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab2JCQpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:45:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51448 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756382Ab2JCQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:45:19 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Clean up some long arch conditionals
Date: Wed,  3 Oct 2012 17:44:22 +0100
Message-Id: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Linus, there are Kconfig or .c files with long
condition checks listing several architectures. These patches attempt to
solve some of them.

Sorry for the long cc but given that the patches are trivial it's not
worth submitting individual patches for each architecture.

Catalin Marinas (4):
  Clean up the long arch list for the UID16 config option
  Clean up the long arch list for the DEBUG_KMEMLEAK config option
  Clean up the long arch list for the DEBUG_BUGVERBOSE config option
  Clean up the "#if defined(arch)" list for exception-trace sysctl
    entry

 arch/arm/Kconfig        |    2 ++
 arch/arm64/Kconfig      |    4 ++++
 arch/blackfin/Kconfig   |    1 +
 arch/cris/Kconfig       |    1 +
 arch/frv/Kconfig        |    2 ++
 arch/h8300/Kconfig      |    1 +
 arch/m32r/Kconfig       |    1 +
 arch/m68k/Kconfig       |    2 ++
 arch/microblaze/Kconfig |    1 +
 arch/mips/Kconfig       |    1 +
 arch/powerpc/Kconfig    |    2 ++
 arch/s390/Kconfig       |    3 +++
 arch/sh/Kconfig         |    3 +++
 arch/sparc/Kconfig      |    5 +++++
 arch/tile/Kconfig       |    3 +++
 arch/um/Kconfig.common  |    1 +
 arch/x86/Kconfig        |    4 ++++
 init/Kconfig            |   11 +++++++++--
 kernel/sysctl.c         |    3 +--
 lib/Kconfig.debug       |   16 ++++++++--------
 20 files changed, 55 insertions(+), 12 deletions(-)


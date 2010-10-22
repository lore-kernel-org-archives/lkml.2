Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0JVMg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:36:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0JVMg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:36:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] asm-generic changes
Date: Fri, 22 Oct 2010 14:36:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221436.46476.arnd@arndb.de>
X-Provags-ID: V02:K0:XJ/IngZXebB9g6TmghUjrLZzJ2Pz1caJimyPiUbzTrX
 /c88X4yAjXvXqSU4RrnAyV78aYMRhAIw6QeD0ZhjyMZmUVfTj2
 fuGrIFWxkQM35zRap9lbJtYilFtI0NpDbV0nNfkOELt//z2+g1
 H/XHncKnAqgyIYuo2yeKXzx9rZYLcbDQ9tUT8ZSUdHVEnLzR/K
 ARr2mG1UlUqwc49GdRpoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few small cleanups and fixes for include/asm-generic.
Please pull from:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git master

---
Akinobu Mita (2):
      bitops: make asm-generic/bitops/find.h more generic
      bitops: remove duplicated extern declarations

Andrea Gelmini (1):
      asm-generic: kdebug.h: Checkpatch cleanup

Lucian Adrian Grijincu (1):
      asm-generic: fcntl: make exported headers use strict posix types

Mathieu Lacage (2):
      asm-generic: make atomic_add_unless a function
      asm-generic: cmpxchg does not handle non-long arguments

Mike Frysinger (1):
      asm-generic/io.h: allow people to override individual funcs

 arch/tile/include/asm/bitops.h    |    1 +
 arch/x86/include/asm/bitops.h     |    2 +
 include/asm-generic/atomic.h      |   34 ++++++++++++++--------------
 include/asm-generic/bitops/find.h |   39 ++++++++++++++++++++++++++++++-
 include/asm-generic/fcntl.h       |    2 +-
 include/asm-generic/io.h          |   26 +++++++++++++++++++++
 include/asm-generic/kdebug.h      |    2 +-
 include/asm-generic/system.h      |   20 +---------------
 include/linux/bitops.h            |   45 -------------------------------------
 9 files changed, 86 insertions(+), 85 deletions(-)

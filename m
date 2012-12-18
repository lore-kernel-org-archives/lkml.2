Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2LROQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:16:06 -0500
Received: from mail.southpole.se ([37.247.8.11]:44978 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab2LROQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:16:04 -0500
Message-ID: <1355840194.2956.81.camel@jerome.southpole.se>
Subject: [GIT PULL] OpenRISC changes for 3.8
From: Jonas Bonn <jonas@southpole.se>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 15:16:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 40158-04066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://openrisc.net/~jonas/linux tags/for-3.8

for you to fetch changes up to 634bd40a894d64df09ba36c12bb6e70787989ba9:

  openrisc: use kbuild.h instead of defining macros in asm-offset.c
(2012-10-25 15:54:33 +0200)

----------------------------------------------------------------
Trivial cleanups for OpenRISC.

----------------------------------------------------------------
James Hogan (1):
      openrisc: use kbuild.h instead of defining macros in asm-offset.c

Steven Rostedt (1):
      openrisc: Use Kbuild infrastructure for kvm_para.h

 arch/openrisc/include/asm/Kbuild          |    1 +
 arch/openrisc/include/uapi/asm/kvm_para.h |    1 -
 arch/openrisc/kernel/asm-offsets.c        |    6 +-----
 3 files changed, 2 insertions(+), 6 deletions(-)
 delete mode 100644 arch/openrisc/include/uapi/asm/kvm_para.h



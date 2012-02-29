Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2B2JaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:30:09 -0500
Received: from mail.southpole.se ([193.12.106.18]:55055 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2B2JaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:30:01 -0500
Message-ID: <1330507800.2964.52.camel@crucifix>
Subject: [GIT PULL] Build fixes for OpenRISC arch
From: Jonas Bonn <jonas@southpole.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 10:30:00 +0100
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 07799-02490
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I know my GPG key isn't in your web of trust, but I figured I'd do a
signed pull request anyway.  The server to pull from is the usual one so
things are about the same as if I'd just asked you to pull a branch.

There's just two small fixes here to enable building the OpenRISC
architecture after changes elsewhere in the kernel didn't get propagated
all the way through into this arch.  Both pretty trivial.

/Jonas

The following changes since commit
d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:

  git://openrisc.net/jonas/linux for-3.3

for you to fetch changes up to 3f6ffc8c2087791920721f086f9a92fde7bed9e2:

  openrisc: Fix up audit_syscall_[entry|exit]() usage (2012-02-17
09:53:12 +0100)

----------------------------------------------------------------
Build fixes for 3.3

----------------------------------------------------------------
Jonas Bonn (2):
      openrisc: include export.h for EXPORT_SYMBOL
      openrisc: Fix up audit_syscall_[entry|exit]() usage

 arch/openrisc/include/asm/ptrace.h |    8 +++++++-
 arch/openrisc/kernel/init_task.c   |    1 +
 arch/openrisc/kernel/irq.c         |    1 +
 arch/openrisc/kernel/ptrace.c      |   12 ++++--------
 4 files changed, 13 insertions(+), 9 deletions(-)



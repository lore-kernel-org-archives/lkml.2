Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2K3XJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 18:09:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab2K3XJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 18:09:27 -0500
Message-ID: <1354316964.1873.11.camel@t520.localdomain>
Subject: [GIT PULL] C6X: fixes for v3.7
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 30 Nov 2012 18:09:24 -0500
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 93bbd0c087eb299e0fe11c59d340932180c082b5:

  c6x: use generic kvm_para.h (2012-11-28 14:33:03 -0500)

----------------------------------------------------------------
C6X fixes for v3.7

----------------------------------------------------------------
Mark Salter (4):
      c6x: run do_notify_resume with interrupts enabled
      c6x: fix misleading comment
      c6x: remove internal kernel symbols from exported setup.h
      c6x: use generic kvm_para.h

 arch/c6x/include/asm/setup.h         |   33 +++++++++++++++++++++++++++++++++
 arch/c6x/include/uapi/asm/Kbuild     |    2 ++
 arch/c6x/include/uapi/asm/kvm_para.h |    1 -
 arch/c6x/include/uapi/asm/setup.h    |   33 +++------------------------------
 arch/c6x/kernel/entry.S              |    5 +++--
 5 files changed, 41 insertions(+), 33 deletions(-)
 create mode 100644 arch/c6x/include/asm/setup.h
 delete mode 100644 arch/c6x/include/uapi/asm/kvm_para.h



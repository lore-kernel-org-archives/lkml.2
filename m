Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2EUSIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454Ab2EUSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:08:51 -0400
Subject: [GIT PULL]  c6x updates for 3.5
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 21 May 2012 13:31:08 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1337621469.15388.1.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 8ff98b9c993d59d6b396a42266c6d323c8f28cec:

  C6X: remove unused config items (2012-05-18 09:59:22 -0400)

----------------------------------------------------------------
Clean up some c6x Kconfig items and add support for Elf FDPIC loader.

----------------------------------------------------------------
Mark Salter (3):
      C6X: change main arch kbuild symbol
      C6X: add support to build with BINFMT_ELF_FDPIC
      C6X: remove unused config items

 arch/c6x/Kconfig              |   14 +-------------
 arch/c6x/include/asm/elf.h    |   14 +++++++++++++-
 arch/c6x/include/asm/mmu.h    |    4 ++++
 arch/c6x/include/asm/ptrace.h |    5 +++++
 fs/Kconfig.binfmt             |    2 +-
 5 files changed, 24 insertions(+), 15 deletions(-)



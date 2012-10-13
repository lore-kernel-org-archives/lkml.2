Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab2JMGTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 02:19:00 -0400
Received: from mail.southpole.se ([193.12.106.18]:48040 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2JMGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 02:18:59 -0400
Message-ID: <1350109135.6232.3.camel@jerome.southpole.se>
Subject: [GIT PULL] OpenRISC UAPI disintegration
From: Jonas Bonn <jonas@southpole.se>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 13 Oct 2012 08:18:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 09135-00451
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pull request contains just the UAPI disintegration work from David
Howells.

/Jonas

------

The following changes since commit
4d7127dace8cf4b05eb7c8c8531fc204fbb195f4:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
(2012-10-13 11:29:00 +0900)

are available in the git repository at:


  git://openrisc.net/jonas/linux tags/openrisc-uapi

for you to fetch changes up to 6257c5740e9f876f4097f6c67ec69576c23abb82:

  Merge tag 'disintegrate-openrisc-20121009' of
git://git.infradead.org/users/dhowells/linux-headers (2012-10-13
07:38:37 +0200)

----------------------------------------------------------------

OpenRISC UAPI disintegration work from David Howells.

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/openrisc/include/asm

Jonas Bonn (1):
      Merge tag 'disintegrate-openrisc-20121009' of
git://git.infradead.org/users/dhowells/linux-headers

 arch/openrisc/include/asm/Kbuild                  |    2 -
 arch/openrisc/include/asm/elf.h                   |   51
+--------------
 arch/openrisc/include/asm/ptrace.h                |   17 +----
 arch/openrisc/include/uapi/asm/Kbuild             |    7 +++
 arch/openrisc/include/{ => uapi}/asm/byteorder.h  |    0
 arch/openrisc/include/uapi/asm/elf.h              |   69
+++++++++++++++++++++
 arch/openrisc/include/{ => uapi}/asm/kvm_para.h   |    0
 arch/openrisc/include/{ => uapi}/asm/param.h      |    0
 arch/openrisc/include/uapi/asm/ptrace.h           |   35 +++++++++++
 arch/openrisc/include/{ => uapi}/asm/sigcontext.h |    0
 arch/openrisc/include/{ => uapi}/asm/unistd.h     |    0
 11 files changed, 113 insertions(+), 68 deletions(-)
 rename arch/openrisc/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/openrisc/include/uapi/asm/elf.h
 rename arch/openrisc/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/openrisc/include/{ => uapi}/asm/param.h (100%)
 create mode 100644 arch/openrisc/include/uapi/asm/ptrace.h
 rename arch/openrisc/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/openrisc/include/{ => uapi}/asm/unistd.h (100%)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab2EHJyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:54:03 -0400
Received: from mail.southpole.se ([193.12.106.18]:56637 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2EHJyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:54:01 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 0/6] OpenRISC patches for review
Date: Tue,  8 May 2012 11:53:59 +0200
Message-Id: <1336470845-13859-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 70835-04945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a couple of patches that I'm planning on queuing up for 3.5.  These
have been through the openrisc mailing list, but there's not much response
on that channel, so I thought I'd run these once by the "big" list.

Comments welcome, otherwise these will go into 3.5.

Thanks,
Jonas

Jonas Bonn (5):
  openrisc: implement irqdomains
  openrisc: remove unnecessary includes
  openrisc: header file cleanups
  openrisc: provide dma_map_ops
  openrisc: use scratch regs in atomic syscall

Kautuk Consul (1):
  openrisc/mm/fault.c: Port OOM changes to do_page_fault

 arch/openrisc/Kconfig                   |    1 +
 arch/openrisc/include/asm/Kbuild        |    3 +-
 arch/openrisc/include/asm/dma-mapping.h |  147 +++++++------------------------
 arch/openrisc/include/asm/elf.h         |   12 ++-
 arch/openrisc/include/asm/ptrace.h      |    6 +-
 arch/openrisc/kernel/dma.c              |  109 +++++++++++++++--------
 arch/openrisc/kernel/entry.S            |    8 +-
 arch/openrisc/kernel/irq.c              |   83 ++++++++++--------
 arch/openrisc/mm/fault.c                |   32 ++++++--
 9 files changed, 199 insertions(+), 202 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2AGTBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 14:01:37 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:58882 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2AGTBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 14:01:35 -0500
Date: Sat, 7 Jan 2012 20:01:22 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.3
Message-ID: <20120107200122.5a78669d@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12010719-6892-0000-0000-000000A46A87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Carsten Otte (1):
      [S390] disable MACHINE_IS_VM check for pfault

Christian Borntraeger (1):
      [S390] kvm: fix sleeping function ... at mm/page_alloc.c:2260

Heiko Carsten (1):
      [S390] sysctl: get rid of dead declaration

Heiko Carstens (9):
      [S390] irq: fix accounting of external call/emergency signal
      [S390] topology: get rid of ifdefs
      [S390] qdio: fix qdio_allocate_aob() declaration
      [S390] topology: cleanup z10 topology handling
      [S390] topology: increase poll frequency if change is anticipated
      [S390] Remove Kerntypes leftovers
      [S390] ipc: call generic sys_ipc demultiplexer
      [S390] Enable exception traces by default
      [S390] disassembler: mark exception causing instructions

Holger Dengler (2):
      [S390] zcrypt: Rework length parameter checking.
      [S390] zcrypt: Fix error return codes.

Jan Glauber (1):
      [S390] make arch/s390 subdirectories depend on config option

Martin Schwidefsky (6):
      [S390] add support for physical memory > 4TB
      [S390] kvm: move cmf host id constant out of lowcore
      [S390] entry[64].S improvements
      [S390] cleanup trap handling
      [S390] outstanding interrupts vs. smp_send_stop
      [S390] return address of compat signals

Michael Holzheu (6):
      [S390] Check for NULL termination in command line setup
      [S390] Rework create_mem_hole() function
      [S390] Remove useless newline in reserve_kdump_bootmem()
      [S390] kernel: Fix smp_switch_to_ipl_cpu() stack frame setup
      [S390] Add VMCOREINFO_SYMBOL(high_memory) to vmcoreinfo
      [S390] Add s390x description to Documentation/kdump/kdump.txt

Stefan Haberland (2):
      [S390] dasd: add sanity check to detect path connection error
      [S390] dasd: fix fixpoint divide exception in define_extent

Stefan Weinhuber (1):
      [S390] dasd: fix expiration handling for recovery requests

Steffen Maier (1):
      [S390] qdio: fix kernel panic for zfcp 31-bit

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


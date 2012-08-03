Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2HCExl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 00:53:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63475 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2HCExZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 00:53:25 -0400
Message-ID: <501B5941.4070200@kernel.org>
Date: Fri, 03 Aug 2012 00:53:21 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management Patches for Linux-3.6-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.

A 3.3 sleep regression fixed, numa bugfix, plus some minor cleanups.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 9d0b01a1bbb7a4ad23000240b67bca33c4235fcf:

  Merge branches 'delete-gts-bfs', 'misc', 'novell-bugzilla-757888-numa' and 'osc-pcie' into base (2012-08-03 00:31:23 -0400)

----------------------------------------------------------------

Feng Tang (1):
      ACPI processor: Fix tick_broadcast_mask online/offline regression

Len Brown (4):
      ACPI: replace strlen("string") with sizeof("string") -1
      ACPI/x86: revert 'x86, acpi: Call acpi_enter_sleep_state via an asmlinkage C function from assembler'
      ACPI: delete _GTS/_BFS support
      Merge branches 'delete-gts-bfs', 'misc', 'novell-bugzilla-757888-numa' and 'osc-pcie' into base

Rafael J. Wysocki (2):
      ACPI / PM: Fix build warning in sleep.c for CONFIG_ACPI_SLEEP unset
      ACPI / PCI: Do not try to acquire _OSC control if that is hopeless

Thomas Renninger (2):
      ACPI: Untangle a return statement for better readability
      ACPI: Only count valid srat memory structures

 arch/ia64/kernel/acpi.c          |  5 +--
 arch/x86/kernel/acpi/sleep.c     |  4 ---
 arch/x86/kernel/acpi/sleep.h     |  2 --
 arch/x86/kernel/acpi/wakeup_32.S |  4 ++-
 arch/x86/kernel/acpi/wakeup_64.S |  4 ++-
 arch/x86/mm/srat.c               | 15 ++++----
 drivers/acpi/acpica/achware.h    | 12 +++----
 drivers/acpi/acpica/hwesleep.c   | 19 ++--------
 drivers/acpi/acpica/hwsleep.c    | 20 ++---------
 drivers/acpi/acpica/hwxfsleep.c  | 22 ++++++------
 drivers/acpi/numa.c              | 12 ++++---
 drivers/acpi/pci_root.c          | 11 ++++--
 drivers/acpi/processor_driver.c  |  2 +-
 drivers/acpi/sleep.c             | 75 ++++++----------------------------------
 drivers/acpi/sysfs.c             |  4 +--
 include/acpi/acpixf.h            |  4 +--
 include/acpi/actypes.h           |  2 +-
 include/linux/acpi.h             |  2 +-
 18 files changed, 73 insertions(+), 146 deletions(-)
[lenb@x980 lenb (next)]$ 

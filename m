Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2F3F2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:28:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45489 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2F3F2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:28:18 -0400
Message-ID: <4FEE8E6A.8060402@kernel.org>
Date: Sat, 30 Jun 2012 01:28:10 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: ACPI & Power Management patches for Linux 3.5-rc4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management bug fixes for 3.5.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 6eca954e25e8a67e48334e668b9ac7da21fcbc6f:

  Merge branches 'acpi_pad-bugzilla-42981', 'apei-bugzilla-43282', 'video-bugzilla-43168', 'bugzilla-40002' and 'bugfix-misc' into release (2012-06-30 00:53:50 -0400)

----------------------------------------------------------------

Feng Tang (3):
      ACPI: Make acpi_skip_timer_override cover all source_irq==0 cases
      ACPI: Remove one board specific WARN when ignoring timer overriding
      ACPI: Add a quirk for "AMILO PRO V2030" to ignore the timer overriding

Huang Ying (1):
      ACPI, APEI, Avoid too much error reporting in runtime

Len Brown (1):
      Merge branches 'acpi_pad-bugzilla-42981', 'apei-bugzilla-43282', 'video-bugzilla-43168', 'bugzilla-40002' and 'bugfix-misc' into release

Pavel Vasilyev (1):
      ACPI sysfs.c strlen fix

Stuart Hayes (1):
      acpi_pad: fix power_saving thread deadlock

Zhang Rui (2):
      ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI
      ACPI video: Still use ACPI backlight control if _DOS doesn't exist

 arch/x86/kernel/acpi/boot.c       | 27 ++++++++++++++++-----------
 arch/x86/kernel/reboot.c          |  8 ++++++++
 drivers/acpi/acpi_pad.c           |  7 ++++---
 drivers/acpi/apei/apei-base.c     | 17 +++++++++++++++--
 drivers/acpi/apei/apei-internal.h |  9 +++++++++
 drivers/acpi/apei/ghes.c          |  6 +++---
 drivers/acpi/sysfs.c              |  4 ++--
 drivers/acpi/video.c              |  2 ++
 8 files changed, 59 insertions(+), 21 deletions(-)

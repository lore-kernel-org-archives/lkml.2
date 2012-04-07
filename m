Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2DGCIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 22:08:55 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54073 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2DGCIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 22:08:54 -0400
Message-ID: <4F7FA1B2.3030903@kernel.org>
Date: Fri, 06 Apr 2012 22:08:50 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management patches for Linux-3.4-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.

Two fixes for cpuidle merge-window changes, plus a URL fix in MAINTAINERS

thanks!
Len Brown, Intel Open Source Technology Center


The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to eeaab2d8af2cf1d36d7086f22e9de42d6dd2995c:

  Merge branches 'idle-fix' and 'misc' into release (2012-04-06 21:48:59 -0400)

----------------------------------------------------------------

Igor Murzov (1):
      MAINTAINERS: Update git url for ACPI

Len Brown (1):
      Merge branches 'idle-fix' and 'misc' into release

Tony Luck (1):
      ACPI processor: Use safe_halt() rather than halt() in acpi_idle_play_dead()

Toshi Kani (1):
      cpuidle: Fix panic in CPU off-lining with no idle driver

 MAINTAINERS                   |    2 +-
 drivers/acpi/processor_idle.c |    2 +-
 drivers/cpuidle/cpuidle.c     |    5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)


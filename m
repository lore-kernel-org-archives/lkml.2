Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3AHPog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:44:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44465 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab3AHPoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:44:34 -0500
Date: Tue, 8 Jan 2013 16:44:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130108154430.GB14536@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the 3 fixes below.

Thanks.

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.8

for you to fetch changes up to 44d22e2404b3ce93a314654962d31acc8afcdd62:

  EDAC: Cleanup device deregistering path (2013-01-07 17:43:00 +0100)

----------------------------------------------------------------
Two error path fixes causing a crash and a Kconfig fix for an issue
which spilled all EDAC suboptions into the 'Device Drivers' menu.

----------------------------------------------------------------
Borislav Petkov (1):
      EDAC: Fix EDAC Kconfig menu

Konstantin Khlebnikov (1):
      EDAC: Fix kernel panic on module unloading

Lans Zhang (1):
      EDAC: Cleanup device deregistering path

 drivers/edac/Kconfig         |  8 +++-----
 drivers/edac/edac_mc_sysfs.c | 19 ++++++-------------
 2 files changed, 9 insertions(+), 18 deletions(-)


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

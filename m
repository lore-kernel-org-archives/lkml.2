Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1AGLAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:00:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1AGLAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:00:19 -0500
Date: Fri, 7 Jan 2011 12:00:28 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MCE EDAC changes for .38
Message-ID: <20110107110028.GD16507@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the second patchset I have for .38 and it adds MCE decoding
support for F15h CPUs. Again, long cooking time in linux-next with no
issues.

Thanks.

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git mce-for-linus

Borislav Petkov (13):
      EDAC, MCE: Select extended error code mask
      EDAC, MCE: Add F15h DC MCE decoder
      EDAC, MCE: Add F15h IC MCE decoder
      EDAC, MCE: Add F15h CU MCE decoder
      EDAC, MCE: No F15h LS MCE decoder
      EDAC, MCE: Add an F15h NB MCE decoder
      EDAC, MCE: Add F15 EX MCE decoder
      EDAC, MCE: Add F15h FP MCE decoder
      EDAC, MCE: Overhaul error fields extraction macros
      EDAC, MCE: Shorten error report formatting
      EDAC, MCE: Allow F15h bank 6 MCE injection
      EDAC, MCE: Enable MCE decoding on F15h
      EDAC, MCE: Fix NB error formatting

Randy Dunlap (1):
      EDAC, MCE: Use BIT_64() to eliminate warnings on 32-bit

 drivers/edac/amd64_edac.c  |    4 +-
 drivers/edac/mce_amd.c     |  450 +++++++++++++++++++++++++++++++++----------
 drivers/edac/mce_amd.h     |   14 +-
 drivers/edac/mce_amd_inj.c |    9 +-
 4 files changed, 359 insertions(+), 118 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab0LINwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:52:39 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56747 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab0LINwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:52:37 -0500
Date: Thu, 9 Dec 2010 14:51:20 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Thompson <norsk5@yahoo.com>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for .37-rc6
Message-ID: <20101209135120.GA20017@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the branch below to receive the latest EDAC fixes.

Thanks.

The following changes since commit cf7d7e5a1980d1116ee152d25dac382b112b9c17:

  Linux 2.6.37-rc5 (2010-12-06 20:09:04 -0800)

are available in the git repository at:
  git//git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Andrei Konovalov (1):
      EDAC: Correct MiB_TO_PAGES() macro

Borislav Petkov (2):
      EDAC: Fix workqueue-related crashes
      amd64_edac: Fix interleaving check

 drivers/edac/amd64_edac.c |    2 +-
 drivers/edac/edac_core.h  |    6 +++---
 drivers/edac/edac_mc.c    |   10 ++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

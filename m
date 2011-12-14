Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1LNPDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:03:08 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43935 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab1LNPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:03:05 -0500
Date: Wed, 14 Dec 2011 16:02:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, edac-devel <linux-edac@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86, MCE: Decode early errors too
Message-ID: <20111214150252.GE23589@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull from the branch below to receive the functionality which
enables decoding of MCEs which have happened early during boot, before
MCA has been initiated.

Also for the next merge window.
Thanks.

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git early-mce-decode

Borislav Petkov (2):
      x86, mce: Add wrappers for registering on the decode chain
      x86, MCE: Drain mcelog buffer

 arch/x86/include/asm/mce.h       |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c |   64 +++++++++++++++++++++++++++++++++----
 drivers/edac/i7core_edac.c       |    4 +-
 drivers/edac/mce_amd.c           |    4 +-
 drivers/edac/sb_edac.c           |    6 +--
 5 files changed, 65 insertions(+), 16 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

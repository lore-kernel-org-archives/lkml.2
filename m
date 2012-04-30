Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2D3NMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:12:42 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40153 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2D3NMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:12:41 -0400
Date: Mon, 30 Apr 2012 15:12:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, x86 <x86@kernel.org>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD MCE thresholding fixes for 3.5
Message-ID: <20120430131232.GH9303@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

those are three patches which should fix the case where the APIC LVT
thresholding interrupt is not supported. No hurry here, it can wait for
the 3.5 merge window,

Thanks.

--
The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/amd-thresholding-fixes-for-3.5

for you to fetch changes up to 575203b4747c371698dd686b1fa6d0a3a0c47ac6:

  x86, MCE, AMD: Disable error thresholding bank 4 on some models (2012-04-30 13:22:54 +0200)

----------------------------------------------------------------
A three-patch set which makes the APIC LVT interrupt optional because a
subset of F15h models don't support it.

----------------------------------------------------------------
Borislav Petkov (3):
      x86, MCE, AMD: Make APIC LVT thresholding interrupt optional
      x86, MCE, AMD: Hide interrupt_enable sysfs node
      x86, MCE, AMD: Disable error thresholding bank 4 on some models

 arch/x86/kernel/cpu/mcheck/mce.c     |   37 +++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   65 ++++++++++++++++++++++++++--------
 2 files changed, 88 insertions(+), 14 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

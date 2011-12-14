Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1LNO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:59:00 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46758 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1LNO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:58:59 -0500
Date: Wed, 14 Dec 2011 15:58:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86, microcode, AMD: Fixes for next merge window
Message-ID: <20111214145846.GD23589@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

as promised, please pull from the branch below to receive the following
fixes, they could be queued for the next merge window and simmer a while
in linux-next until then.

Thanks.

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-verify-size

Borislav Petkov (5):
      x86, microcode, AMD: Add a vendor-specific exit function
      x86, microcode, AMD: Add a reusable buffer
      x86, microcode, AMD: Simplify ucode verification
      x86, microcode, AMD: Exit early on success
      x86, microcode, AMD: Update copyrights

 arch/x86/include/asm/microcode.h |    2 +
 arch/x86/kernel/microcode_amd.c  |  209 +++++++++++++++++++++-----------------
 arch/x86/kernel/microcode_core.c |    5 +
 3 files changed, 121 insertions(+), 95 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

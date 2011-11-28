Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1K1UnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:43:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46424 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1K1UnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:43:13 -0500
Date: Mon, 28 Nov 2011 21:43:11 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86, microcode fixes for 3.2
Message-ID: <20111128204311.GA2814@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull the following two fixes for the microcode machinery.

Thanks.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode

Borislav Petkov (1):
      x86, microcode, AMD: Restrict microcode reporting

Srivatsa S. Bhat (1):
      x86, microcode: Fix the failure path of microcode update driver init code

 arch/x86/kernel/cpu/amd.c        |    3 ++-
 arch/x86/kernel/microcode_core.c |   19 +++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2JINEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:04:20 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37691 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab2JINEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:04:16 -0400
Date: Tue, 9 Oct 2012 15:04:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS: Numascale fix
Message-ID: <20121009130402.GB26450@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

just a small fix for an oops on Numascale's confederate systems. It can
go in ASAP.

Thanks.



The following changes since commit 547b1e81afe3119f7daf702cc03b158495535a25:

  Fix staging driver use of VM_RESERVED (2012-10-09 21:06:41 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/numascale_mce_fix

for you to fetch changes up to 124556ec1555b89af76cec3e41375b6f9a557ead:

  x86, AMD, MCE: Prevent oops on multi-server system (2012-10-09 14:48:43 +0200)

----------------------------------------------------------------
A fix for a bug causing an OOPS on confederate systems from Numascale
where northbridge descriptors are not unique, causing a lookup failure
of the northbridge descriptor in the amd_nb.c code.

A more general fix is in the works.

----------------------------------------------------------------
Daniel J Blueman (1):
      x86, AMD, MCE: Prevent oops on multi-server system

 arch/x86/kernel/cpu/mcheck/mce_amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2CGLmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:42:06 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:55612 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab2CGLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:42:00 -0500
Date: Wed, 7 Mar 2012 12:41:38 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] mce: Fix RCU warning
Message-ID: <20120307114138.GA21202@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

the following fixes an RCU splat which at least Srivatsa and I can
trigger. It would be lovely if it went in into tip:urgent and to Linus
before 3.3 is out.

Oh, and I ventured a try with signed tags, it looks good from here but
let me know if I've missed anything.

Thanks a lot.

The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

  Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/mce-fix-for-3.3-rc6

for you to fetch changes up to b11e3d782b9c065b3b2fb543bfb0d97801822dc0:

  x86, mce: Fix rcu splat in drain_mce_log_buffer() (2012-03-07 11:44:29 +0100)

----------------------------------------------------------------
Fix a RCU warning in MCE code

----------------------------------------------------------------
Srivatsa S. Bhat (1):
      x86, mce: Fix rcu splat in drain_mce_log_buffer()

 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

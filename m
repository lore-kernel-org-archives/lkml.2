Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1JMOjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:39:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57135 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab1JMOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:39:09 -0400
Date: Thu, 13 Oct 2011 16:38:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 <x86@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 ucode fix
Message-ID: <20111013143848.GA3064@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull from the branch below to receive a small ucode driver
hotplug optimization.

The following changes since commit 37cf95162af4036b4198756a590aab8126fa2ce4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2011-10-13 18:25:45 +1200)

are available in the git repository at:

  git://amd64.org/linux/bp.git ucode

Srivatsa S. Bhat (1):
      x86, microcode: Don't request microcode from userspace unnecessarily

 arch/x86/kernel/microcode_core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

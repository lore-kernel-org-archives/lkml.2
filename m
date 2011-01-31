Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1AaN3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:29:48 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33405 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab1AaN3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:29:47 -0500
Date: Mon, 31 Jan 2011 14:30:24 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD microcode fixes
Message-ID: <20110131133024.GC32230@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo,

please pull from the branch below to receive a bunch of AMD microcode
driver fixes and cleanups. They are not strictly needed for .38 so
you could easily postpone them for .39 but still have them cook in
linux-next.

Patches survived testing here and were out for review a week ago:
http://marc.info/?l=linux-kernel&m=129588278209579

There's one out-of-tree change to <drivers/base/sys.c> which Greg hasn't
explicitly acked yet but judging by his silence he has nothing against
it :).

Thanks.

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-fixes

Borislav Petkov (7):
      sysdev: Do not register with sysdev when erroring on add
      x86, microcode: Correct sysdev_add error path
      x86, microcode, AMD: Release firmware on error
      x86, microcode, AMD: Simplify install_equiv_cpu_table
      x86, microcode, AMD: Simplify get_next_ucode
      x86, microcode, AMD: Remove unneeded memset call
      x86, microcode, AMD: Cleanup dmesg output

 arch/x86/kernel/microcode_amd.c  |  142 ++++++++++++++++++--------------------
 arch/x86/kernel/microcode_core.c |    6 +-
 drivers/base/sys.c               |   65 ++++++++++++-----
 3 files changed, 118 insertions(+), 95 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

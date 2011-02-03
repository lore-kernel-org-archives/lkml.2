Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab1BCNtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:49:00 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36808 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1BCNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:48:59 -0500
Date: Thu, 3 Feb 2011 14:50:06 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT revised PULL] AMD microcode fixes
Message-ID: <20110203135006.GC24755@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

here's a revised pull request without the <drivers/base/sys.c> portion.
Still a .39 material and thus in no hurry.

Please pull,
thanks.

The following changes since commit ebf53826e105f488f4f628703a108e98940d1dc5:

  Linux 2.6.38-rc3 (2011-02-01 13:05:49 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-fixes

Borislav Petkov (6):
      x86, microcode: Correct sysdev_add error path
      x86, microcode, AMD: Release firmware on error
      x86, microcode, AMD: Simplify install_equiv_cpu_table
      x86, microcode, AMD: Simplify get_next_ucode
      x86, microcode, AMD: Remove unneeded memset call
      x86, microcode, AMD: Cleanup dmesg output

 arch/x86/kernel/microcode_amd.c  |  142 ++++++++++++++++++--------------------
 arch/x86/kernel/microcode_core.c |    6 +-
 2 files changed, 72 insertions(+), 76 deletions(-)

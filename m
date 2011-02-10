Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1BJL7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:59:35 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50091 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1BJL7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:59:34 -0500
Date: Thu, 10 Feb 2011 12:59:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <greg@kroah.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD microcode fixes, updated
Message-ID: <20110210115952.GC12244@aftab>
References: <20110203135006.GC24755@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203135006.GC24755@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 08:50:06AM -0500, Borislav Petkov wrote:
> here's a revised pull request without the <drivers/base/sys.c> portion.
> Still a .39 material and thus in no hurry.

Hi Ingo,

in case you haven't pulled yet, I've added one more patch to the pull
request.

Thanks.

The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

  Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-fixes

Borislav Petkov (7):
      x86, microcode: Correct sysdev_add error path
      x86, microcode, AMD: Release firmware on error
      x86, microcode, AMD: Simplify install_equiv_cpu_table
      x86, microcode, AMD: Simplify get_next_ucode
      x86, microcode, AMD: Remove unneeded memset call
      x86, microcode, AMD: Cleanup dmesg output
      x86, microcode, AMD: Extend ucode size verification

 arch/x86/kernel/microcode_amd.c  |  188 +++++++++++++++++++++-----------------
 arch/x86/kernel/microcode_core.c |    6 +-
 2 files changed, 109 insertions(+), 85 deletions(-)


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

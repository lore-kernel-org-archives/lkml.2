Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2KTV0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:26:46 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57575 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab2KTV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:26:44 -0500
Message-ID: <1353446800.13269.2.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: [GIT PULL] EFI changes for v3.7 - part 2
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Tue, 20 Nov 2012 21:26:40 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

The following changes since commit 226f69a4b7ed1da248d653aa1535bad61ba5fa49:

  Merge tag 'please-pull-tangchen' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/urgent (2012-11-13 19:01:01 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.7-v2

for you to fetch changes up to 0f905a43ce955b638139bd84486194770a6a2c08:

  x86, efi: Fix processor-specific memcpy() build error (2012-11-20 20:52:07 +0000)

----------------------------------------------------------------
EFI updates for v3.7 - part 2

  * Fix the i386 EFI boot stub build for 3DNow memcpy configs.

  * Delete an unused 'long' in header.S that was part of the initial
    EFI boot stub commit, but is no long referenced.

----------------------------------------------------------------
Cesar Eduardo Barros (1):
      x86: remove dummy long from EFI stub

Matt Fleming (1):
      x86, efi: Fix processor-specific memcpy() build error

 arch/x86/boot/compressed/eboot.c | 2 ++
 arch/x86/boot/header.S           | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center


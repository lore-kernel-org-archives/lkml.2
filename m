Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1FPPcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:32:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45681 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab1FPPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:32:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [GIT PULL] x86, microcode, AMD: 2 small fixlets
Date: Thu, 16 Jun 2011 17:32:05 +0200
Message-Id: <1308238327-27965-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi Ingo,

please pull the following fixes from the below branch.

They are only minor correctness fixes and can be queued for 3.1.

Thanks.

The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-fixes

Borislav Petkov (2):
      x86, microcode, AMD: Correct buf references
      x86, microcode, AMD: Fix section header size check

 arch/x86/kernel/microcode_amd.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)


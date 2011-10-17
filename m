Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1JQPZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:25:37 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34631 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1JQPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:25:35 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] x86, microcode: AMD adjustments
Date: Mon, 17 Oct 2011 17:25:13 +0200
Message-Id: <1318865115-9904-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

this should take care of the recent addition of microcode revision to
/proc/cpuinfo for AMD too. Patches are against tip/x88/microcode and
available also on

git://amd64.org/linux/bp.git tip-ucode

Please pull,
thanks.

The following changes since commit ca8bc8dc044793ee4d59ff7fe40138eee27d0325:

  coretemp: Get microcode revision from cpu_data (2011-10-14 13:16:42 +0200)

are available in the git repository at:
  git://amd64.org/linux/bp.git tip-ucode

Borislav Petkov (2):
      x86, microcode: Correct microcode revision format
      x86, microcode, AMD: Add microcode revision to /proc/cpuinfo

 arch/x86/kernel/cpu/amd.c        |    4 ++++
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 arch/x86/kernel/cpu/proc.c       |    2 +-
 arch/x86/kernel/microcode_amd.c  |    5 +++--
 4 files changed, 9 insertions(+), 4 deletions(-)

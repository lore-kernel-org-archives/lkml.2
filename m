Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2LKLNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:13:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56509 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2LKLNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:13:20 -0500
Date: Tue, 11 Dec 2012 12:13:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/ras changes for v3.8
Message-ID: <20121211111314.GA26721@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   HEAD: 003db633d6f2d3649ea18652a3c55ad17d4f0e47 Merge tag 'mca_cfg' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/ras

Rework all config variables used throughout the MCA code and 
collect them together into a mca_config struct. This keeps them 
tightly and neatly packed together instead of spilled all over 
the place.
    
Then, convert those which are used as booleans into real 
booleans and save some space.

out-of-topic modifications in x86-ras-for-linus:
------------------------------------------------
drivers/base/core.c                # 9187239: drivers/base: Add a DEVICE_BOOL_A
include/linux/device.h             # 9187239: drivers/base: Add a DEVICE_BOOL_A

 Thanks,

	Ingo

------------------>
Borislav Petkov (5):
      drivers/base: Add a DEVICE_BOOL_ATTR macro
      x86, MCA: Convert dont_log_ce, banks and tolerant
      x86, MCA: Convert rip_msr, mce_bootlog, monarch_timeout
      x86, MCA: Convert the next three variables batch
      x86, MCA: Finish mca_config conversion


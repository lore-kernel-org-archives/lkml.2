Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2HEVin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:38:43 -0400
Received: from zougloub.eu ([188.165.233.99]:54295 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab2HEVim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:38:42 -0400
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2012 17:38:42 EDT
Date: Sun, 5 Aug 2012 17:29:03 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, matt.fleming@linux.intel.com
Subject: [Regression] "x86-64/efi: Use EFI to deal with platform wall clock"
 prevents my machine from booting
Message-ID: <20120805172903.5f8bb24c@zougloub.eu>
Organization: none
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My PC (AMD Bulldozer + Asus SABERTOOTH 990FX) booted fine from UEFI
and it broke between v3.5 and v3.6-rc1.
Other machines with old BIOSes booted fine so I looked into EFI-related
patches trying to revert them, because I didn't know what else to do.

Bingo, bacef661: x86-64/efi: Use EFI to deal with platform wall clock.

At the moment I reverted this commit after v3.6-rc1-133-g42a579a,
and it boots fine.

This really not my domain so tell me if I can help testing.

Regards,

-- 
cJ

Note, probably irrelevant: I use grub2 with no boot parameters
except root= and the standard .config EFI options.

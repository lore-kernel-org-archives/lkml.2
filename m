Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2JWLGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:06:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54318 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2JWLGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:06:31 -0400
Date: Tue, 23 Oct 2012 13:06:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20121023110626.GA28620@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 235d220e1b55c1f8683fd4f59c3e8e39ba6ca915 Merge tag 'numascale_mce_fix' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/urgent

Fix for a system with an atypical use of AMD CPUs.

 Thanks,

	Ingo

------------------>
Daniel J Blueman (1):
      x86, AMD, MCE: Prevent oops on multi-server system




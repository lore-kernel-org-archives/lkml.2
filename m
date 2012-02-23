Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2BWGcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:32:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37685 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2BWGck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:32:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of udknight@gmail.com designates 10.50.222.132 as permitted sender) smtp.mail=udknight@gmail.com; dkim=pass header.i=udknight@gmail.com
Date: Thu, 23 Feb 2012 14:32:19 +0800
From: Wang YanQing <udknight@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@linux.intel.com, x86@kernel.org, spock@gentoo.org
Subject: [PATCH 0/2] x86: add function to check whether BIOS NX and let
 uvesafb work
Message-ID: <20120223063219.GB3886@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	hpa@linux.intel.com, x86@kernel.org, spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
https://lkml.org/lkml/2011/11/17/54 is the first time I
post the question I meet.At that time, I haven't idea to 
catch it bug! My computer hang too early, and even seral 
console doesn't help.
Recent days I try to compile uvesafb as a module, and insert 
it when I have a full work kernel, X11, and sshd. Good dog,
the bug occurs again, and I catch it!
Here are the two patches that I try to fix it,
I will appreciate for any comments.Thanks

attached patches:
1/2 x86:add function to check BIOS whether NX
2/2 video:uvesafb: check whether BIOS is NX before try to use PMI

---
 arch/x86/include/asm/pci.h |    1 +
 arch/x86/mm/pageattr.c     |    2 +-
 arch/x86/pci/pcbios.c      |   11 +++++++++++
 drivers/video/uvesafb.c    |    6 ++++++
 4 files changed, 19 insertions(+), 1 deletions(-)
---

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3ACGNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:13:38 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52542 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3ACGNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:13:36 -0500
Message-ID: <1357193608.3924.37.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 03 Jan 2013 17:13:28 +1100
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010306-5490-0000-0000-000002BCD850
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a couple of small powerpc fixes. They aren't new bugs (and
they are both CCed to stable) but I didn't see the point of sitting
on the fixes any longer.

Oh and happy new year !

Cheers,
Ben.

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git 

for you to fetch changes up to e6449c9b2d90c1bd9a5985bf05ddebfd1631cd6b:

  powerpc: Add missing NULL terminator to avoid boot panic on PPC40x (2013-01-03 16:45:52 +1100)

----------------------------------------------------------------
Gabor Juhos (1):
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

 arch/powerpc/kernel/time.c                 |    5 -----
 arch/powerpc/platforms/40x/ppc40x_simple.c |    3 ++-
 2 files changed, 2 insertions(+), 6 deletions(-)



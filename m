Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2CaHgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:36:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49452 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab2CaHgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:36:21 -0400
Message-ID: <1333179378.2994.18.camel@dabdike.sthat4.btopenzone.com>
Subject: [GIT PULL] parisc updates for the 3.3+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 31 Mar 2012 08:36:18 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a couple of minor updates (fixing lws futex locking and removing
some obsolete cpu_*_map calls).

The update is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git parisc-misc

The short changelog is:

John David Anglin (1):
      [PARISC] futex: Use same lock set as lws calls

Rusty Russell (1):
      [PARISC] remove references to cpu_*_map.

And the diffstat:

 arch/parisc/include/asm/futex.h |   31 +++++++++++++++++++++++++++----
 arch/parisc/kernel/smp.c        |    3 +--
 2 files changed, 28 insertions(+), 6 deletions(-)

James



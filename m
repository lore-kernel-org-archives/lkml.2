Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0LPHdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:33:09 -0500
Received: from ozlabs.org ([203.10.76.45]:34757 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0LPHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:33:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest fixes
Date: Thu, 16 Dec 2010 18:03:03 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161803.03942.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ The arch/x86/kernel/head_32.S changes are to expose a couple of symbols ]

The following changes since commit b0c3844d8af6b9f3f18f31e1b0502fbefa2166be:

  Linux 2.6.37-rc6 (2010-12-15 17:24:48 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (3):
      lguest: fix crash lguest_time_init
      lguest: restore boot speed
      lguest: populate initial_page_table

 arch/x86/kernel/head_32.S   |    4 +-
 arch/x86/lguest/boot.c      |   16 +++---
 arch/x86/lguest/i386_head.S |  105 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 10 deletions(-)

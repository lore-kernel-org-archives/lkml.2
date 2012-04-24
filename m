Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2DXSX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:23:29 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50813 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab2DXSX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:23:26 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 0/2] Buildtime exception table sorting for relative entries.
Date: Tue, 24 Apr 2012 11:23:13 -0700
Message-Id: <1335291795-26693-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

These are against HPA's x86/extable branch in the tip repo.

Light testing indicates that it works for x86_64, and MIPS64.  x86_32
looks good, but I didn't try to boot the resulting kernel.  But really,
what could go wrong with something so simple?

David Daney (2):
  scripts/sortextable: Handle relative entries, and other cleanups.
  Revert "x86, extable: Disable presorted exception table for now"

 arch/x86/Kconfig      |    1 +
 scripts/Makefile      |    2 +
 scripts/sortextable.c |  171 ++++++++++++++++++++++++++++++++-----------------
 scripts/sortextable.h |   79 +++++++++++++++--------
 4 files changed, 165 insertions(+), 88 deletions(-)

-- 
1.7.7.6


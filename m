Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab2J3MVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:21:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab2J3MU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:20:59 -0400
Date: Tue, 30 Oct 2012 05:20:45 -0700
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-487ba8e82ab98320e5d7c0f6ff6da3067505ff92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de
In-Reply-To: <1351532410-4887-3-git-send-email-bp@alien8.de>
References: <1351532410-4887-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] MAINTAINERS: Change Boris' email address
Git-Commit-ID: 487ba8e82ab98320e5d7c0f6ff6da3067505ff92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:20:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  487ba8e82ab98320e5d7c0f6ff6da3067505ff92
Gitweb:     http://git.kernel.org/tip/487ba8e82ab98320e5d7c0f6ff6da3067505ff92
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 29 Oct 2012 18:40:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:05:51 +0100

MAINTAINERS: Change Boris' email address

Move to private mail address.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1351532410-4887-3-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fa9074..e775b87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2707,10 +2707,10 @@ F:	include/linux/edac.h
 
 EDAC-AMD64
 M:	Doug Thompson <dougthompson@xmission.com>
-M:	Borislav Petkov <borislav.petkov@amd.com>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
-S:	Supported
+S:	Maintained
 F:	drivers/edac/amd64_edac*
 
 EDAC-E752X
@@ -3703,7 +3703,7 @@ S:	Maintained
 F:	drivers/platform/x86/ideapad-laptop.c
 
 IDE/ATAPI DRIVERS
-M:	Borislav Petkov <petkovbb@gmail.com>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	Documentation/cdrom/ide-cd
@@ -8147,7 +8147,7 @@ F:	drivers/platform/x86
 
 X86 MCE INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>
-M:	Borislav Petkov <bp@amd64.org>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*

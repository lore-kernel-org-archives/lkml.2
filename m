Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2LMEil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:38:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2LMEik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:38:40 -0500
Date: Wed, 12 Dec 2012 20:38:25 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-4bfe24ac1d9d9f06b30b2909f53ea462c72cfe1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        ebiederm@xmission.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        ebiederm@xmission.com
In-Reply-To: <50C95832.5030306@zytor.com>
References: <50C95832.5030306@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc:
  Add a formal bootloader ID for kexec-tools
Git-Commit-ID: 4bfe24ac1d9d9f06b30b2909f53ea462c72cfe1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Dec 2012 20:38:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bfe24ac1d9d9f06b30b2909f53ea462c72cfe1d
Gitweb:     http://git.kernel.org/tip/4bfe24ac1d9d9f06b30b2909f53ea462c72cfe1d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 12 Dec 2012 20:24:12 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 12 Dec 2012 20:25:43 -0800

x86, doc: Add a formal bootloader ID for kexec-tools

Add bootloader id D for kexec-tools (it is kexec-tools, not the kexec
system call, that builds the data structures, therefore it is
kexec-tools which is the "bootloader" for this purpose.)

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/50C95832.5030306@zytor.com
---
 Documentation/x86/boot.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..c25a53e 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -381,6 +381,7 @@ Protocol:	2.00+
 	A  Gujin
 	B  Qemu
 	C  Arcturus Networks uCbootloader
+	D  kexec-tools
 	E  Extended		(see ext_loader_type)
 	F  Special		(0xFF = undefined)
        10  Reserved

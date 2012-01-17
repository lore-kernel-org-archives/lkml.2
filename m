Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2AQWnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:43:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2AQWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:43:49 -0500
Date: Tue, 17 Jan 2012 14:43:37 -0800
From: tip-bot for Ulrich Drepper <drepper@gmail.com>
Message-ID: <tip-ce79dac861e0d9a473d9923391bdbaad83c1c57f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        drepper@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        drepper@gmail.com, tglx@linutronix.de
In-Reply-To: <CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com>
References: <CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, opcode: ANDN and Group 17 in x86-opcode-map.
 txt
Git-Commit-ID: ce79dac861e0d9a473d9923391bdbaad83c1c57f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 14:43:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce79dac861e0d9a473d9923391bdbaad83c1c57f
Gitweb:     http://git.kernel.org/tip/ce79dac861e0d9a473d9923391bdbaad83c1c57f
Author:     Ulrich Drepper <drepper@gmail.com>
AuthorDate: Tue, 17 Jan 2012 14:14:02 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 17 Jan 2012 12:11:54 -0800

x86, opcode: ANDN and Group 17 in x86-opcode-map.txt

The Intel documentation at

http://software.intel.com/file/36945

shows the ANDN opcode and Group 17 with encoding f2 and f3 encoding
respectively.  The current version of x86-opcode-map.txt shows them
with f3 and f4.  Unless someone can point to documentation which shows
the currently used encoding the following patch be applied.

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/x86-opcode-map.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5b83c51..4c8010d 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -729,8 +729,8 @@ de: VAESDEC Vdq,Hdq,Wdq (66),(v1)
 df: VAESDECLAST Vdq,Hdq,Wdq (66),(v1)
 f0: MOVBE Gy,My | MOVBE Gw,Mw (66) | CRC32 Gd,Eb (F2)
 f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2)
-f3: ANDN Gy,By,Ey (v)
-f4: Grp17 (1A)
+f2: ANDN Gy,By,Ey (v)
+f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v)
 f6: MULX By,Gy,rDX,Ey (F2),(v)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)

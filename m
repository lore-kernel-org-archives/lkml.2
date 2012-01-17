Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2AQTO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:14:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40738 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2AQTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:14:25 -0500
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 17 Jan 2012 14:14:02 -0500
Message-ID: <CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com>
Subject: ANDN and Group 17 in x86-opcode-map.txt
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        pp-manager@sdl.hitachi.co.jp
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel documentation at

http://software.intel.com/file/36945

shows the ANDN opcode and Group 17 with encoding f2 and f3 encoding
respectively.  The current version of x86-opcode-map.txt shows them
with f3 and f4.  Unless someone can point to documentation which shows
the currently used encoding the following patch be applied.

Signed-off-by: Ulrich Drepper <drepper@gmail.com>

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
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By
(F3),(v) | SHRX Gy,Ey,By (F2),(v)

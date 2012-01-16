Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2APAkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:40:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60058 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2APAkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:40:46 -0500
MIME-Version: 1.0
In-Reply-To: <4F136FED.8090201@hitachi.com>
References: <CAOPLpQc_TfvtfJ0NL+4fsi2r_eW+4qWX+WbXrZ9BjGn44nAmBw@mail.gmail.com>
 <4F136FED.8090201@hitachi.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 15 Jan 2012 19:40:24 -0500
Message-ID: <CAOPLpQfytPyDEBF1Hbkpo7ovUerEsstVGxBr=EpDL-BKEMaqLA@mail.gmail.com>
Subject: Re: Typo transferred from Intel manual
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 19:31, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Could you add a comment line above the fix in x86-opcode-map.txt?
> I just consider the case that someone may confuse the fix itself
> is typo.

Find the changed patch below.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5b83c51..c292885 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -219,7 +219,9 @@ ab: STOS/W/D/Q Yv,rAX
 ac: LODS/B AL,Xb
 ad: LODS/W/D/Q rAX,Xv
 ae: SCAS/B AL,Yb
-af: SCAS/W/D/Q rAX,Xv
+# Note: The May 2011 Intel manual shows Xv for the second parameter of the
+# next instruction but Yv is correct
+af: SCAS/W/D/Q rAX,Yv
 # 0xb0 - 0xbf
 b0: MOV AL/R8L,Ib
 b1: MOV CL/R9L,Ib

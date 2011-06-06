Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1FFRbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:31:13 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:59325 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756161Ab1FFRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:31:10 -0400
X-AuditID: 12074423-b7ce8ae000000a29-69-4ded0ed8fe23
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Mikael Pettersson <mikpe@it.uu.se>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/3] x86-64: Fix outdated comments in vsyscall_64.c
Date: Mon,  6 Jun 2011 13:27:23 -0400
Message-Id: <ab1699caaea6c7863fb74abc2f5718353680070c.1307380481.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307380481.git.luto@mit.edu>
References: <cover.1307380481.git.luto@mit.edu>
In-Reply-To: <cover.1307380481.git.luto@mit.edu>
References: <cover.1307380481.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42IR4hTV1r3B99bXYOsGDYu+K0fZLaZtFLe4
	vGsOm8WT5uuMFlsuNbNaPF7znNniUd9bdosfGx6zOnB43Gr7w+yxpOMHu8fOWXfZPf6/PMLm
	sWlVJ5vHiRm/WTw+b5LzONHyhTWAI4rLJiU1J7MstUjfLoEr43frQraCM+wVd24vZGtgbGDr
	YuTkkBAwkbjUdZUVwhaTuHBvPVCci0NIYB+jxNZ/R9ghnPWMEn/nz2WEcA4xSVzsuMEC0sIm
	oCLRsfQBE4gtIqAv8fvsIrAiZoHnjBIvPpwA2yEs4CzRs+cQWBGLgKrEv6mtQDYHB69AkMSi
	xhgQU0JAQeL8qnyQCk4BA4mpt2cxgthCQCPP75vMikt8AqPAAkaGVYyyKblVurmJmTnFqcm6
	xcmJeXmpRbpmermZJXqpKaWbGEFBze6ivIPxz0GlQ4wCHIxKPLza39/4CrEmlhVX5h5ilORg
	UhLl/cv71leILyk/pTIjsTgjvqg0J7X4EKMEB7OSCG/8G6By3pTEyqrUonyYlDQHi5I471xJ
	dV8hgfTEktTs1NSC1CKYrAwHh5IErzMweoUEi1LTUyvSMnNKENJMHJwgw3mAhs/jAKrhLS5I
	zC3OTIfIn2LU5dh64u1BRiGWvPy8VClx3jiQQQIgRRmleXBzYMnoFaM40FvCvBYgVTzARAY3
	6RXQEiagJcedXoEsKUlESEk1MBr390zn/1anfzXIf3bN39evDBIv7lr3OD9EVPC6/vbvnD/j
	55+wXbB9omPXRZ88cfF1/iy8ql/2nZ8e80NUsLeUze2t/YHWm0ecvPoCDn3871fg0d3spXVf
	TsNEupZ9epfSpOr3u3vuzX695fG71pNHVRa/13sXwqHNsDotIKL38bvbdU28vEosxRmJhlrM
	RcWJAOx35uAhAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vsyscall_64.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 27d49b7..0b50b3c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -11,10 +11,11 @@
  *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
  *  jumping out of line if necessary. We cannot add more with this
  *  mechanism because older kernels won't return -ENOSYS.
- *  If we want more than four we need a vDSO.
  *
- *  Note: the concept clashes with user mode linux. If you use UML and
- *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
+ *  This mechanism is deprecated in favor of the vDSO.
+ *
+ *  Note: the concept clashes with user mode linux.  UML users should
+ *  use the vDSO.
  */
 
 /* Disable profiling for userspace code: */
-- 
1.7.5.2


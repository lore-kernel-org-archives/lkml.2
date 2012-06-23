Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2FWDGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:06:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2FWDGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:06:42 -0400
X-Authority-Analysis: v=2.0 cv=bpjO9Tmi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=CuxqB1YDpxEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120623030548.500374594@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 22 Jun 2012 23:05:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/3] [ANNOUNCE] 3.4.3-rt12-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.4.3-rt12-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 6/24/2012.

Enjoy,

-- Steve


To build 3.4.3-rt12-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.3.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.3-rt12-rc1.patch.xz

You can also build from 3.4.3-rt11 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.3-rt11-rt12-rc1.patch.xz


Changes from 3.4.3-rt11:

---


Steven Rostedt (2):
      spinlock/rt: Include bug.h in spinlock_rt.h to satisfy BUG() usage
      Linux 3.4.3-rt12-rc1

Thomas Gleixner (1):
      Oops during Init IRQ

----
 arch/powerpc/platforms/8xx/m8xx_setup.c |    1 +
 arch/powerpc/sysdev/cpm1.c              |    1 +
 include/linux/spinlock_rt.h             |    2 ++
 localversion-rt                         |    2 +-
 4 files changed, 5 insertions(+), 1 deletion(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2CVCfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:35:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2CVCe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:34:57 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=u39DOwJ-51YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120322023309.083011587@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 22:33:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/3] [ANNOUNCE] 3.0.25-rt44-rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.25-rt44-rc2.

This release added the patch from 3.2-rt:
   printk-disable-migration-instead-of-preemption.patch
as Luis Claudio R. Goncalves pointed out as missing.
 
Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 3/23/2012.

Enjoy,

-- Steve


To build 3.0.25-rt44-rc2 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.25.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.25-rt44-rc2.patch.xz

You can also build from 3.0.25-rt43 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.25-rt43-rt44-rc2.patch.xz


Changes from 3.0.25-rt43:

---


Richard Weinberger (1):
      printk: Disable migration instead of preemption

Steven Rostedt (2):
      Revert "kprobes: adjust "fix a memory leak in function pre_handler_kretprobe()""
      Linux 3.0.25-rt44-rc2

----
 kernel/kprobes.c |    4 ++--
 kernel/printk.c  |    4 ++--
 localversion-rt  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

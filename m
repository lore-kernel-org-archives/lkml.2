Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2JaAaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:30:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2JaA3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:29:47 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qUrVBOFqLPYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evC8euxjDUgA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121031002910.195421780@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Oct 2012 20:29:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/4] [ANNOUNCE] 3.4.15-rt26-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.4.15-rt26-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 11/2/2012.

Enjoy,

-- Steve


To build 3.4.15-rt26-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.15.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.15-rt26-rc1.patch.xz

You can also build from 3.4.15-rt25 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.15-rt25-rt26-rc1.patch.xz


Changes from 3.4.15-rt25:

---


Steven Rostedt (1):
      Linux 3.4.15-rt26-rc1

Thomas Gleixner (2):
      rcu: Disable RCU_FAST_NO_HZ on RT
      net: netfilter: Serialize xt_write_recseq sections on RT

Watanabe (1):
      hrtimer: Raise softirq if hrtimer irq stalled

----
 include/linux/locallock.h          |    4 ++++
 include/linux/netfilter/x_tables.h |    7 +++++++
 init/Kconfig                       |    2 +-
 kernel/hrtimer.c                   |    9 ++++-----
 localversion-rt                    |    2 +-
 net/netfilter/core.c               |    6 ++++++
 6 files changed, 23 insertions(+), 7 deletions(-)

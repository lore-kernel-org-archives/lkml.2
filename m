Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2IMSyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:54:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2IMSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:54:13 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=x5DI6aYItr4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evC8euxjDUgA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120913185234.912247144@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 14:52:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/2] [ANNOUNCE] 3.0.42-rt64-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.42-rt64-rc1.

----
Note: The patches have not been uploaded to kernel.org yet. I've
recently changed the subkey that I use to sign the patches as the
old subkey is about to expire. But unfortunately, kernel.org has
not updated its key ring, and is refusing my current subkey.

I have a ticket open with kernel.org to resolve the issue. But until
then, this mailing is the only place the patches exist.
----

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 9/17/2012.

Enjoy,

-- Steve


To build 3.0.42-rt64-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.42.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.42-rt64-rc1.patch.xz

You can also build from 3.0.42-rt63 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.42-rt63-rt64-rc1.patch.xz


Changes from 3.0.42-rt63:

---


Frank Rowand (1):
      fix printk flush of messages

Steven Rostedt (1):
      Linux 3.0.42-rt64-rc1

----
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/tty/sysrq.c                         |   23 -----------------------
 include/linux/sysrq.h                       |    5 -----
 kernel/printk.c                             |    5 ++---
 lib/Kconfig.debug                           |   22 ----------------------
 localversion-rt                             |    2 +-
 6 files changed, 4 insertions(+), 55 deletions(-)

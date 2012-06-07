Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040Ab2FGPn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:43:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2FGPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:43:15 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=H-07P_7U_BcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120607154222.443210802@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Jun 2012 11:42:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/4] [ANNOUNCE] 3.2.19-rt31-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.19-rt31-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 6/12/2012.

Enjoy,

-- Steve


To build 3.2.19-rt31-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.19.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.19-rt31-rc1.patch.xz

You can also build from 3.2.19-rt30 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.19-rt30-rt31-rc1.patch.xz


Changes from 3.2.19-rt30:

---


John Kacur (1):
      scsi: qla2xxx: Use local_irq_save_nort() in qla2x00_poll

Priyanka Jain (1):
      net,RT:REmove preemption disabling in netif_rx()

Steven Rostedt (1):
      Linux 3.2.19-rt31-rc1

Thomas Gleixner (1):
      mips-remove-smp-reserve-lock.patch

----
 arch/mips/cavium-octeon/smp.c     |    6 ------
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++--
 localversion-rt                   |    2 +-
 net/core/dev.c                    |    8 ++++----
 4 files changed, 7 insertions(+), 13 deletions(-)

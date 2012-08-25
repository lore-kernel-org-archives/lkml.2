Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2HYDRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:17:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2HYDQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:16:58 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BlSqUYE9ltwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=SqtfypCTco8A:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120825031219.772181128@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 24 Aug 2012 23:12:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/2] [ANNOUNCE] 3.2.28-rt42-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.28-rt42-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 8/29/2012 (The late Michael Jackson's B-Day, and also one of
my friends from high school, who hated Michael Jackson, and also
hated to be reminded that he shared the same B-Day).

Enjoy,

-- Steve


To build 3.2.28-rt42-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.28.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.28-rt42-rc1.patch.xz

You can also build from 3.2.28-rt41 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.28-rt41-rt42-rc1.patch.xz


Changes from 3.2.28-rt41:

---


Frank Rowand (1):
      fix printk flush of messages

Steven Rostedt (1):
      Linux 3.2.27-rt41-rc1

----
 kernel/printk.c |    2 +-
 localversion-rt |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

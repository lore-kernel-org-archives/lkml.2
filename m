Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2LLAyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:54:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2LLAyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:54:14 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5A5jmJ4_9VYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evC8euxjDUgA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212005342.348897923@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Dec 2012 19:53:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/2] [ANNOUNCE] 3.0.55-rt80-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.55-rt80-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 12/14/2012, let's hope it's not an unexpected journey!

Enjoy,

-- Steve


To build 3.0.55-rt80-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.55.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.55-rt80-rc1.patch.xz

You can also build from 3.0.55-rt79 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.55-rt79-rt80-rc1.patch.xz


Changes from 3.0.55-rt79:

---


Steven Rostedt (1):
      Linux 3.0.55-rt80-rc1

Thomas Gleixner (1):
      sched: Queue RT tasks to head when prio drops

----
 kernel/sched.c  |   16 ++++++++++++----
 localversion-rt |    2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

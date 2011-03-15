Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1CODvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:51:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59652 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1CODvu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 14 Mar 2011 23:51:50 -0400
Date: Mon, 14 Mar 2011 23:51:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: owen.smith@citrix.com, jaxboe@fusionio.com, Ian.Campbell@eu.citrix.com,
        tony.luck@intel.com, drjones@redhat.com
Subject: [GIT PULL] (xen) stable/ia64, stable/blkfront-cleanup, and
 stable/cleanup for 2.6.39
Message-ID: <20110315035129.GC820@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D7EE245.0059,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull these three branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ia64 stable/blkfront-cleanup stable/cleanup

Or you take #for-2.6.39/cleanup which has these three merges (no conflicts) for your convience.

Back to the description.

#stable/irq.rework is based off v2.6.38-rc6 (f5412be599602124d2bdd49947b231dd77c0bf99)

.. fixes a build-time mess up on IA64 when using Xen there.

#stable/blkfront-cleanup is based off v2.6.38-rc1 (c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470)

.. and it shuffles a struct around for further work.

#stable/cleanup is based off v2.6.38-rc4 (100b33c8bd8a3235fd0b7948338d6cbb3db3c63d)

.. and it does a general cleanup of compile warnings.

 arch/ia64/include/asm/xen/hypercall.h |    2 +-
 arch/x86/xen/enlighten.c              |    2 +-
 arch/x86/xen/p2m.c                    |    6 +++---
 drivers/block/xen-blkfront.c          |    8 ++++----
 drivers/xen/events.c                  |    2 +-
 include/xen/interface/io/blkif.h      |   16 +++++++++++-----
 6 files changed, 21 insertions(+), 15 deletions(-)

Ian Campbell (4):
      xen: events: mark cpu_evtchn_mask_p as __refdata
      xen p2m: annotate variable which appears unused
      xen: annotate functions which only call into __init at start of day
      xen: ia64 build broken due to "xen: switch to new schedop hypercall by default."

Owen Smith (1):
      xen: Union the blkif_request request specific fields


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1FTNOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:14:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53550 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1FTNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:12:30 -0400
Date: Mon, 20 Jun 2011 09:12:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: stefano.stabellini@eu.citrix.com, sven.koehler@gmail.com,
        tom.goetz@virtualcomputer.com, drjones@redhat.com
Subject: [GIT PULL] (xen) bug-fixes for 3.0-rc3: stable/bug.fixes
Message-ID: <20110620131209.GA10215@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DFF4735.009C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus

Please pull the following git branch:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which has these patches since git commit f124c6ae59e193705c9ddac57684d50006d710e6
Dan Carpenter(1):
  xen: off by one errors in multicalls.c

(which you had merged some time ago).

The patches in this git pull fix compile warnings; fix bootup issues when CONFIG_MAXSMP
is used, when the initrd image is quite small; and properly shutdown the kernel (wrong arguments
to a hypercall).

The diffstat:

 arch/x86/xen/enlighten.c |    9 ++++++++-
 arch/x86/xen/mmu.c       |   12 ++++++++++--
 arch/x86/xen/setup.c     |   10 ++++++----
 arch/x86/xen/smp.c       |    7 +++++++
 drivers/xen/events.c     |    2 +-
 5 files changed, 32 insertions(+), 8 deletions(-)

The changelog:

Andrew Jones (1):
      xen: support CONFIG_MAXSMP

Konrad Rzeszutek Wilk (2):
      xen: Fix compile warning when CONFIG_SMP is not defined.
      xen/setup: Fix for incorrect xen_extra_mem_start.

Stefano Stabellini (1):
      xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"

Tom Goetz (1):
      xen: When calling power_off, don't call the halt function.


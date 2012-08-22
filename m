Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2HVQTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:19:45 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:39292 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab2HVQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:19:42 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336348800"; 
   d="scan'208";a="14131461"
Date: Wed, 22 Aug 2012 17:19:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/6] Xen patches for Linux 3.7
Message-ID: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,
the followings are the patches that I am proposing for Linux 3.7.
I am leaving out the bulk of the ARM patches for the moment.


Stefano Stabellini (6):
      xen/events: fix unmask_evtchn for PV on HVM guests
      xen: missing includes
      xen: update xen_add_to_physmap interface
      xen: Introduce xen_pfn_t for pfn and mfn types
      xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
      xen: allow privcmd for HVM guests

 arch/ia64/include/asm/xen/interface.h      |    7 ++++++-
 arch/x86/include/asm/xen/interface.h       |    7 +++++++
 arch/x86/xen/mmu.c                         |    3 +++
 drivers/tty/hvc/hvc_xen.c                  |    2 ++
 drivers/xen/events.c                       |   18 +++++++++++++++---
 drivers/xen/grant-table.c                  |    1 +
 drivers/xen/privcmd.c                      |    4 ----
 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 include/xen/interface/grant_table.h        |    4 ++--
 include/xen/interface/memory.h             |    9 ++++++---
 include/xen/interface/platform.h           |    4 ++--
 include/xen/interface/xen.h                |    7 +++----
 include/xen/privcmd.h                      |    3 +--
 13 files changed, 49 insertions(+), 21 deletions(-)


A git branch based on v3.6-rc2 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git for_upstream_3.7

Cheers,

Stefano

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab2JTBaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:30:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41610 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2JTBaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:30:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mukesh.rathor@oracle.com, Ian.Campbell@citrix.com,
        stefano.stabellini@eu.citrix.com
Subject: 
Date: Fri, 19 Oct 2012 21:17:56 -0400
Message-Id: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mukesh provided me with the git of his with some of the changes to his
patches and as well the modifications done per review. I've done a bit
of changes in the git description to flesh them out some more.

Sending them out and I've also stuck the redone patches in my tree:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v4

Please review. I think the only changes are just in the git commit
descriptions - so please pull our your wordsmith hat and lupe!

 arch/x86/include/asm/xen/interface.h |   11 ++-
 arch/x86/include/asm/xen/page.h      |    3 +
 arch/x86/xen/Kconfig                 |   10 ++
 arch/x86/xen/enlighten.c             |   77 ++++++++++++----
 arch/x86/xen/irq.c                   |    5 +-
 arch/x86/xen/mmu.c                   |  162 ++++++++++++++++++++++++++++++++--
 arch/x86/xen/mmu.h                   |    2 +
 arch/x86/xen/p2m.c                   |    2 +-
 arch/x86/xen/setup.c                 |   64 +++++++++++---
 arch/x86/xen/smp.c                   |   75 ++++++++++------
 arch/x86/xen/xen-head.S              |   11 ++-
 drivers/xen/balloon.c                |   15 ++--
 drivers/xen/cpu_hotplug.c            |    4 +-
 drivers/xen/events.c                 |    9 ++-
 drivers/xen/gntdev.c                 |    3 +-
 drivers/xen/grant-table.c            |   26 +++++-
 drivers/xen/privcmd.c                |   72 ++++++++++++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 +-
 include/xen/interface/memory.h       |   24 +++++-
 include/xen/interface/physdev.h      |   10 ++
 include/xen/xen-ops.h                |    5 +-
 21 files changed, 507 insertions(+), 86 deletions(-)


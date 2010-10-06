Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab0JFQdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:33:00 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:45290 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0JFQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:32:58 -0400
X-IronPort-AV: E=Sophos;i="4.57,290,1283731200"; 
   d="scan'208";a="2219284"
Date: Wed, 6 Oct 2010 17:33:19 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] Xen PV on HVM fixes for 2.6.36 rc6
Message-ID: <alpine.DEB.2.00.1010061727510.2440@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull 

  git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git v2.6.36-rc6-urgent-fixes

to get the two following fixes.

Thanks in advance,

Stefano

---

Stefano Stabellini (2):
      xen: do not set xenstored_ready before xenbus_probe on hvm
      xen: do not initialize PV timers on HVM if !xen_have_vector_callback

 arch/x86/xen/time.c               |    5 +++--
 drivers/xen/xenbus/xenbus_probe.c |    9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

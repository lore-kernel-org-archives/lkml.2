Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0ERK3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:29:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:48808 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416Ab0ERK3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:29:09 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 06:29:09 EDT
X-IronPort-AV: E=Sophos;i="4.53,254,1272859200"; 
   d="scan'208";a="8558169"
Date: Tue, 18 May 2010 11:22:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 0 of 12] PV on HVM Xen
Message-ID: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the fixed, updated and rebased version of the PV on HVM series:
the series is based on 2.6.34 now and supports Xen PV frontends running
in a HVM domain, including netfront, blkfront and the VIRQ_TIMER.

The list of bugs fixed in this update includes: xenbus drivers crashes
when xenbus is not properly initialized, a memory corruption bug in
suspend/resume and testing for the xen platform pci version and protocol
has been moved to enlighten.c (before unplugging emulated devices).

In order to be able to use VIRQ_TIMER and to improve performances you
need a patch to Xen to implement the vector callback mechanism
for event channel delivery.

A git tree is also available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git

branch name 2.6.34-pvhvm.

Cheers,

Stefano


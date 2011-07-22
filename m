Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1GVDde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 23:33:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46829 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1GVDdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 23:33:33 -0400
Date: Thu, 21 Jul 2011 23:33:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: rprabhu@wnohang.net
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.1
Message-ID: <20110722033315.GA22901@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E28EF88.0049:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following branch:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which has one patch since git commit 155a16f21923bc2f04161ac92acca986371ef27b
Konrad Rzeszutek Wilk (1):
    xen/pci: Use the INT_SRC_OVR IRQ (instead of GSI) to preset the ACPI SCI IRQ.

which you pulled in 3.0-rc6 time-frame.

The patch fixed a section mismatch - which we never hit in production b/c the code
was inlined. But it is still a bug.

Raghavendra D Prabhu (1):
      xen:pvhvm: Modpost section mismatch fix

arch/x86/xen/platform-pci-unplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


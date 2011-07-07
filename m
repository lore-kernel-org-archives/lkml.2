Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1GGOEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:04:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:65111 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1GGOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:04:28 -0400
Date: Thu, 7 Jul 2011 10:03:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: rprabhu@wnohang.net, ijc@hellion.org.uk
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.0-rc6
Message-ID: <20110707140357.GA2903@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E15BCDC.002E:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which is based on git commit 155a16f21923bc2f04161ac92acca986371ef27b
Konrad Rzeszutek Wilk (1):
    xen/pci: Use the INT_SRC_OVR IRQ (instead of GSI) to preset the ACPI SCI IRQ.

which you pulled in 3.0-rc5 time-frame.

This git pull contains a module section mismatch fix. It reshuffles code around
so that we only use the __initdata variable during bootime, not later in the
lifecycle.

Konrad Rzeszutek Wilk (1):
      xen/pci: Move check for acpi_sci_override_gsi to xen_setup_acpi_sci.

 arch/x86/pci/xen.c |   56 ++++++++++++++++++++++++++--------------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

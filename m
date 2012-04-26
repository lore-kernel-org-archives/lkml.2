Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab2DZSfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:35:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44758 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab2DZSfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] fixes for v3.4-rc4.
Date: Thu, 26 Apr 2012 14:29:21 -0400
Message-Id: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going to ask Linus to pull these patches for 3.4-rc4.

 arch/x86/xen/enlighten.c         |    4 +++-
 arch/x86/xen/smp.c               |   15 +++++++++++++++
 drivers/xen/events.c             |    2 +-
 drivers/xen/xen-acpi-processor.c |    5 ++++-
 4 files changed, 23 insertions(+), 3 deletions(-)

Konrad Rzeszutek Wilk (3):
      xen/enlighten: Disable MWAIT_LEAF so that acpi-pad won't be loaded.
      xen/smp: Fix crash when booting with ACPI hotplug CPUs.
      xen/acpi: Workaround broken BIOSes exporting non-existing C-states.

Stefano Stabellini (1):
      xen: use the pirq number to check the pirq_eoi_map


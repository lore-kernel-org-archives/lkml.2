Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab1HXWby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:31:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16748 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1HXWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:31:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com
Subject: [PATCH] Xen PCI and Xen SWIOTLB patches for 3.2
Date: Wed, 24 Aug 2011 18:31:31 -0400
Message-Id: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E557BD3.003B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these five patches for 3.2.

Nothing really exciting about them - just update some comments, fix
comments, and also make Xen SWIOTLB a bit smarter. Please take a look.

 drivers/pci/xen-pcifront.c |    4 ++--
 drivers/xen/pci.c          |   11 +++++++----
 drivers/xen/swiotlb-xen.c  |   42 +++++++++++++++++++++++++++++-------------
 3 files changed, 38 insertions(+), 19 deletions(-)

Jan Beulich (1):
      xen/pci: make bus notifier handler return sane values

Konrad Rzeszutek Wilk (3):
      xen-pcifront: Update warning comment to use 'e820_host' option.
      xen-swiotlb: Retry up three times to allocate Xen-SWIOTLB
      xen-swiotlb: Fix wrong panic.

Randy Dunlap (1):
      xen-swiotlb: fix printk and panic args


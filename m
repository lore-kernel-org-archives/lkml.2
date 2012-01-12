Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2ALRJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:09:24 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50739 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2ALRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:08:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] xen-pciback features for v3.4 (FLR). v2
Date: Thu, 12 Jan 2012 12:06:45 -0500
Message-Id: <1326388007-19178-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F0F139A.00D4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these patches in your v3.4 branch. A bunch of folks using
Xen chatted a bit about this and it is a worthwile to have this functionality
in the kernel.

Thanks!

The two patches are:
 [PATCH 1/2] pci: Introduce __pci_reset_function_locked to be used
 [PATCH 2/2] xen/pciback: Support pci_reset_function, aka FLR or D3

 drivers/pci/pci.c                  |   25 ++++++++++++++++++++++
 drivers/xen/xen-pciback/pci_stub.c |   41 +++++++++++++++++++++++++++++++++--
 drivers/xen/xen-pciback/pciback.h  |    1 +
 include/linux/pci.h                |    1 +
 4 files changed, 65 insertions(+), 3 deletions(-)

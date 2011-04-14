Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1DNPcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:32:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18207 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1DNPcY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:32:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Provide infrastructure changes for backends (especially pciback) for 2.6.40
Date: Thu, 14 Apr 2011 11:30:09 -0400
Message-Id: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA71385.00AF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've posted these patches in the past, and fixed some of the issues, and I think
there were reviewed. These five pathches are proposed for 2.6.40 to to allow the
Xen-pciback backend module to work.

The patches are located in devel/backend.base.v3
(git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git)

The diffstat is:

 arch/x86/include/asm/xen/pci.h |   16 +++++++
 arch/x86/pci/xen.c             |   94 +++++++++++++++++++++++++++++++++++++--
 drivers/xen/events.c           |   39 ++++++++++++++--
 include/xen/events.h           |    9 +++-
 4 files changed, 147 insertions(+), 11 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1FOTMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:12:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1FOTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:12:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] stable/bug.fixes patches for 3.0-rc4
Date: Wed, 15 Jun 2011 15:11:31 -0400
Message-Id: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4DF903FF.00BE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these for 3.0-rc4 as bug-fixes. They have been ratling around
in some branches, or (as in the CONFIG_MAXSMP) posted in 2008. One of them
is a compile fix while the other affect how Linux boots (or shuts down)
under the Xen hypervisor

Andrew Jones (1):
      xen: support CONFIG_MAXSMP

Konrad Rzeszutek Wilk (1):
      xen: Fix compile warning when CONFIG_SMP is not defined.

Stefano Stabellini (1):
      xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"

Tom Goetz (1):
      xen: When calling power_off, don't call the halt function.

 arch/x86/xen/enlighten.c |    9 ++++++++-
 arch/x86/xen/mmu.c       |   12 ++++++++++--
 arch/x86/xen/smp.c       |    7 +++++++
 drivers/xen/events.c     |    2 +-
 4 files changed, 26 insertions(+), 4 deletions(-)

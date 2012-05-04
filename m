Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab2EDOKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:10:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18089 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab2EDOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:10:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH] patches for v3.5-rc6.
Date: Fri,  4 May 2012 10:04:23 -0400
Message-Id: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was thinking to push these patches to Linus for v3.5-rc6.

 arch/x86/xen/enlighten.c    |   40 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/xen/mmu.c          |    7 ++++++-
 drivers/video/xen-fbfront.c |   25 +++++++++++++++----------
 3 files changed, 59 insertions(+), 13 deletions(-)

David Vrabel (1):
      xen/pci: don't use PCI BIOS service for configuration space accesses

Julia Lawall (1):
      drivers/video/xen-fbfront.c: add missing cleanup code

Konrad Rzeszutek Wilk (2):
      xen/apic: Return the APIC ID (and version) for CPU 0.
      xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs


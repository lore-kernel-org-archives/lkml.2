Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2J2OUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:20:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18978 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2J2OUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:20:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH v1] Bug-fixes for v3.7 back-ported from Jan's postings.
Date: Mon, 29 Oct 2012 10:08:16 -0400
Message-Id: <1351519698-11069-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are back-ports from the ones that Jan posted. Please
take a look  - I might have missed an email about one of the patches
and I can't find it my mailbox :-(

Either way, was thinking to put these in v3.7.

 arch/x86/include/asm/xen/hypercall.h     |   21 +++-----
 drivers/xen/Makefile                     |    2 +-
 drivers/xen/fallback.c                   |   78 ++++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_dev_frontend.c |    2 +-
 4 files changed, 87 insertions(+), 16 deletions(-)


Jan Beulich (2):
      xen/hypercall: fix hypercall fallback code for very old hypervisors
      xen/xenbus: fix overflow check in xenbus_file_write()


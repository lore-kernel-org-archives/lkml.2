Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2GWShR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:37:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19788 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2GWShO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:37:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] docs and cleanups for v3.6 (v1)
Date: Mon, 23 Jul 2012 14:28:18 -0400
Message-Id: <1343068103-13579-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little of docs, cleanups of code, and some extra bits to make
reporting more pleasing to eyes.

 arch/x86/xen/enlighten.c |   41 ++++++++++++++++++++++++++++++---
 arch/x86/xen/mmu.c       |   25 ++++++++++++++------
 arch/x86/xen/p2m.c       |   19 ++++++++++-----
 arch/x86/xen/setup.c     |    9 -------
 arch/x86/xen/xen-head.S  |   56 ++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/xen-ops.h   |    2 +-
 6 files changed, 121 insertions(+), 31 deletions(-)

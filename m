Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1EYVi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:38:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49102 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1EYVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:38:56 -0400
From: Konrad@dumpdata.com, Rzeszutek@dumpdata.com, Wilk@dumpdata.com
To: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Date: Wed, 25 May 2011 17:37:32 -0400
Message-Id: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4DDD76BA.00D4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey stable-tree maintainer(s).

The follow four patches are in the 2.6.40 tree and should be back-ported to 2.6.39 (only).
I forgot to CC:stable on them, so manually doing it here.

The four patches in question have the following git commits:

8c5950881c3b5e6e350e4b0438a8ccc513d90df9
    xen/p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings
0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3
    xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit
15bfc094517db2ddf38ca7ed47f3a1c0ad24f7c4
    xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
7899891c7d161752f29abcc9bc0a9c6c3a3af26c
    xen mmu: fix a race window causing leave_mm BUG()

And are part of this email chain. Please apply them to 2.6.39.1 tree.

Thank you.

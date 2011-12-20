Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1LTGoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:44:32 -0500
Received: from 206-223-182-18.beanfield.net ([206.223.182.18]:38090 "EHLO
	dev.gridcentric.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1LTGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:44:16 -0500
From: Adin Scannell <adin@scannell.ca>
To: xen-devel@lists.xensource.com
Cc: konrad@darnok.org, andres@gridcentric.ca, adin@gridcentric.com,
        olaf@aepfle.de, JBeulich@suse.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add kernel bits necessary to suport Xen paging
Date: Tue, 20 Dec 2011 01:36:50 -0500
Message-Id: <1324363013-11031-1-git-send-email-adin@scannell.ca>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This queue now incorporates the feedback received on the last round (sent to
xen-devel), and an additional patch to fix-up the same bits in the original
mmap_batch ioctl.

Here's a summary of this round:
1 - Tiny patch to correctly return the error value for mmu update operations.
2 - Tiny bit of cleanup in the original mmap_batch ioctl.
3 - Implementation of mmap_batch_v2 required by libxc to support paging.

Missing this round however, is the patch that adds support for backend drivers.
These drivers will need retry grant operations appropriate when they receive an
EAGAIN.  This patch will be reworked and sent out independently.

Cheers!
-Adin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0HIRxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:53:45 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:8113 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0HIRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:53:41 -0400
From: kxie@chelsio.com
Message-Id: <201008091753.o79HrTA4020145@localhost.localdomain>
Date: Mon, 09 Aug 2010 10:53:29 -0700
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Subject: [PATCH 0/3] cxgbi iscsi driver
Cc: rranjan@chelsio.com, kxie@chelsio.com,
        James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 0/3] cxgbi iscsi driver

From: Karen Xie <kxie@chelsio.com>

This patchset includes:

1. added libcxgbi as the common library for both cxgb4i and cxgb3i driver

2. added cxgb4i iscsi initiator v5.

   This updated cxgb4i version incorporates the comments from Mike to
   identify more common functions to be moved to the libcxgbi.

   The cxgb4i driver provides iscsi acceleration (PDU offload and payload data
   direct placement) to the open-iscsi initiator. It accesses the hardware
   through the cxgb4 module.

3. changed cxgb3i to use libcxgbi.

Thanks.
Karen

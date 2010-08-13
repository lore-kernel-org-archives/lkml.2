Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290Ab0HMC5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 22:57:38 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:16414 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0HMC5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 22:57:34 -0400
From: kxie@chelsio.com
Message-Id: <201008130257.o7D2vLkc001280@localhost.localdomain>
Date: Thu, 12 Aug 2010 19:57:21 -0700
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Subject: [PATCH v2 0/3] cxgbi iscsi driver
Cc: rranjan@chelsio.com, kxie@chelsio.com,
        James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2 0/3] cxgbi iscsi driver

From: Karen Xie <kxie@chelsio.com>

This patchset includes:

1. added libcxgbi as the common library for both cxgb4i and cxgb3i driver
2. added cxgb4i iscsi initiator v5.
3. changed cxgb3i to use libcxgbi.

The version 2 includes the following changes:
- Made dbg_level static to avoid compiling errors when both cxgb3i and cxgb4i
  are built into the kernel.
- Deleted cxgbi_fill_iscsi_transport() and cxgbi_fill_scsi_host_template().
  The iscsi_transport and scsi_host_template are initialized in the drivers
  instead of being filled in by the library at runtime..
- Only register with iscsi class transport once per driver type. 

Thanks.
Karen

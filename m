Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1KDS1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:27:21 -0400
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:48914 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755255Ab1KDS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:27:17 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  4 Nov 2011 11:26:41 -0700
Message-Id: <1320431201-29880-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few more 3.2 merge window changes:

 - a panic fix for the qib hardware driver
 - a couple of cleanups to iSER's use of the DMA mapping API
 - a fix to mthca that reduces memory use a bit

Mike Marciniszyn (1):
      IB/qib: Fix panic in RC error flushing logic

Or Gerlitz (2):
      IB/iser: Use separate buffers for the login request/response
      IB/iser: DMA unmap TX bufs used for iSCSI/iSER headers

Roland Dreier (2):
      IB/mthca: Fix buddy->num_free allocation size
      Merge branches 'iser', 'mthca' and 'qib' into for-next

 drivers/infiniband/hw/mthca/mthca_mr.c       |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c           |   10 ++-----
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   11 ++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    4 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   31 ++++++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   33 ++++++++++++++++++++-----
 6 files changed, 64 insertions(+), 27 deletions(-)

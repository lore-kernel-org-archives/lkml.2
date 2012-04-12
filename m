Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920Ab2DLXp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:45:56 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:51524 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753197Ab2DLXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:45:54 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 12 Apr 2012 16:45:44 -0700
Message-Id: <1334274344-12422-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/srpt-srq-type fixes

----------------------------------------------------------------
Add a fix for a bug hit by Alexey Shvetsov in ib_srtp that hits on
non-mlx4 hardware.

----------------------------------------------------------------
Roland Dreier (1):
      IB/srpt: Set srq_type to IB_SRQT_BASIC

 drivers/infiniband/ulp/srpt/ib_srpt.c |    1 +
 1 file changed, 1 insertion(+)

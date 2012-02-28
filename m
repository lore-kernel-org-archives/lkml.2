Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965852Ab2B1RVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:21:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965832Ab2B1RVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.101.72 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/5] trivial remoteproc/rpmsg fixes
Date: Tue, 28 Feb 2012 19:21:07 +0200
Message-Id: <1330449672-18191-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330449672-18191-1-git-send-email-ohad@wizery.com>
References: <1330449672-18191-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Five trivial remoteproc/rpmsg fixes.

One was reported by Russell (the Kconfig fixes) and one by Omar (the endpoint
leak).

Ohad Ben-Cohen (5):
  remoteproc: make sure we're parsing a 32bit firmware
  remoteproc/omap: two Kconfig fixes
  rpmsg: fix name service endpoint leak
  rpmsg: validate incoming message length before propagating
  rpmsg: fix published buffer length in rpmsg_recv_done

 drivers/remoteproc/Kconfig           |    3 +-
 drivers/remoteproc/remoteproc_core.c |    8 ++++++
 drivers/rpmsg/virtio_rpmsg_bus.c     |   42 ++++++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 9 deletions(-)

-- 
1.7.5.4


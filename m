Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1DPQuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:50:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:50041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab1DPQur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:50:47 -0400
Message-Id: <20110416165038.986214764@aepfle.de>
User-Agent: quilt/0.47-15.10
Date: Sat, 16 Apr 2011 18:50:38 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/5] hv cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rebase patches to linux-next-20110415

 drivers/staging/hv/blkvsc_drv.c  |   70 +++++++++++++++++++-------------------
 drivers/staging/hv/connection.c  |   46 ++++++++++--------------
 drivers/staging/hv/hv_mouse.c    |    4 +-
 drivers/staging/hv/netvsc.c      |    2 +-
 drivers/staging/hv/storvsc.c     |    6 ++--
 drivers/staging/hv/storvsc_drv.c |    4 +-
 drivers/staging/hv/vmbus_drv.c   |    8 ++---
 7 files changed, 65 insertions(+), 75 deletions(-)

Olaf



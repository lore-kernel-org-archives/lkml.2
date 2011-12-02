Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1LBKDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:03:32 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1LBKDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:03:30 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 0/3] wl128x: fix multiple signedness bugs
Date: Fri,  2 Dec 2011 05:01:10 -0500
Message-Id: <1322820073-19347-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple signedness bugs which would break the error handling.

Xi Wang (3):
  wl128x: fmdrv_common: fix signedness bugs
  wl128x: fmdrv_rx: fix signedness bugs
  wl128x: fmdrv_tx: fix signedness bugs

 drivers/media/radio/wl128x/fmdrv_common.c |   58 ++++++++++----------
 drivers/media/radio/wl128x/fmdrv_common.h |   28 +++++-----
 drivers/media/radio/wl128x/fmdrv_rx.c     |   84 +++++++++++++++--------------
 drivers/media/radio/wl128x/fmdrv_rx.h     |   50 +++++++++---------
 drivers/media/radio/wl128x/fmdrv_tx.c     |   61 +++++++++++----------
 drivers/media/radio/wl128x/fmdrv_tx.h     |   20 ++++----
 6 files changed, 151 insertions(+), 150 deletions(-)

-- 
1.7.5.4


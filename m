Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1GGTCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:02:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab1GGTCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:02:19 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH 0/4] Apply these staging:iio patches to staging-next.
Date: Thu,  7 Jul 2011 12:01:53 -0700
Message-Id: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are made from
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git staging-next
instead of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
as the previous patches were.

Found another bug there, so there are 4 patches instead of 3.

Bryan Freed (4):
  staging:iio: Reorder channel type strings to match the iio.h enums.
  staging:iio: Add an iio channel type string to support proximity
    sensors.
  staging:iio:light:isl29018: Convert some of the isl29018 driver to
    the new iio_chan_spec framework.
  staging:iio:light:isl29018: Fix the "Init of isl29018 fails" failure.

 drivers/staging/iio/industrialio-core.c |   11 +-
 drivers/staging/iio/light/isl29018.c    |  174 ++++++++++++++----------------
 2 files changed, 87 insertions(+), 98 deletions(-)

-- 
1.7.3.1


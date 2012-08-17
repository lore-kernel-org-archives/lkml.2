Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2HQO5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:57:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42876 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2HQO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:57:36 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 0/4] mtd-utils/ubiattach: introduce max_beb_per1024 in UBI_IOCATT
Date: Fri, 17 Aug 2012 16:57:18 +0200
Message-Id: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,
Here are the patches splitted for the UBI_IOCATT ioctl.
I separated the ubi-user.h in 3 patches:
one sync before my kernel change, another before dropping
CONFIG_MTD_UBI_BEB_LIMIT, and another after.
(If you decide not to drop CONFIG_MTD_UBI_BEB_LIMIT in the kernel, it will be
easier, and you can always squash the first 2 or 3 patches into 1).

Best Regards,
Richard.

Richard Genoud (4):
  sync include/mtd/ubi-user.h with kernel v3.6-rc1
  sync include/mtd/ubi-user.h: add max_beb_per1024 parameter
  sync include/mtd/ubi-user.h: DROP CONFIG_MTD_UBI_BEB_LIMIT
  ubiattach: introduce max_beb_per1024 in UBI_IOCATT

 include/mtd/ubi-user.h             |  155 +++++++++++++++++++----------------
 tests/fs-tests/integrity/integck.c |    1 +
 ubi-utils/include/libubi.h         |    2 +
 ubi-utils/libubi.c                 |    2 +
 ubi-utils/ubiattach.c              |   41 ++++++++--
 5 files changed, 122 insertions(+), 79 deletions(-)

-- 
1.7.2.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab2EWNyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:54:52 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50434 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642Ab2EWNyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAJHrvE9bdWOb/2dsb2JhbABDtDOBB4JDUoEyDAGIJAe6QASQTwOVHI9wgmw
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630123"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] fix errors in the match process
Date: Wed, 23 May 2012 15:54:39 +0200
Message-Id: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As Dan Carpenter suggested, I split the previous patches [0] in several ones,
facilitating the reading, understanding and, at the end, the review and
maintenance.

These patches fix some problems found in the match() process for the ipack
devices, among minor things.

Thanks,

Sam

[0] Link to the patches:

https://lkml.org/lkml/2012/5/23/99
https://lkml.org/lkml/2012/5/23/102
https://lkml.org/lkml/2012/5/23/96

Samuel Iglesias Gonsalvez (8):
  Staging ipack/bridges/tpci200: delete sysfs files
  Staging: ipack: return proper value in match() function
  Staging: ipack/bridges/tpci200: tpci200_slot_unmap_space() should
    return 0 if succeed.
  Staging: ipack/bridges/tpci200: tpci200_slot_map_space() should
    return 0 if succeed.
  Staging: ipack/bridges/tpci200: check if the remove function is
    available
  Staging: ipack/bridges/tpci200: fix indention.
  Staging: ipack/bridges/tpci200: remove name field from slot_irq
  Staging ipack/bridges/tpci200: removed check of
    tpci200->slots[dev->slot].dev

 drivers/staging/ipack/bridges/tpci200.c |  260 +++----------------------------
 drivers/staging/ipack/bridges/tpci200.h |    2 -
 drivers/staging/ipack/ipack.c           |    2 +-
 3 files changed, 24 insertions(+), 240 deletions(-)

-- 
1.7.10


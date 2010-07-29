Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab0G2X61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:58:27 -0400
Received: from mail.perches.com ([173.55.12.10]:2164 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab0G2X60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:58:26 -0400
From: Joe Perches <joe@perches.com>
To: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] drivers/net/bfin_mac.c: Neatening
Date: Thu, 29 Jul 2010 16:58:21 -0700
Message-Id: <cover.1280447281.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ho-hum, broken up into pieces just for Mike Frysinger.

Still uncompiled, untested

Joe Perches (3):
  drivers/net/bfin_mac.c: Neatening
  drivers/net/bfin_mac.c: Use pr_<level>, netdev_<level>
  drivers/net/bfin_mac.c: Misc function cleanups, neatening

 drivers/net/bfin_mac.c |  329 ++++++++++++++++++++++++++----------------------
 1 files changed, 176 insertions(+), 153 deletions(-)

-- 
1.7.2.19.g9a302


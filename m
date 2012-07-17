Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2GQLLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:11:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38532 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2GQLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:10:59 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.15.109]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 17 Jul 2012 14:10:38 +0300
Message-ID: <CAK=Wgbas=HSg1b4c3=vQSns0jPe5j_NTg-rk56q_g6AzbEGysQ@mail.gmail.com>
Subject: [GIT PULL] rpmsg: 1-liner fix for 3.5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Federico Fuga <fuga@studiofuga.com>, linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git
tags/single-rpmsg-3.5-fix

for you to fetch changes up to 9634252617441991b01dacaf4040866feecaf36f:

  rpmsg: fix dependency on initialization order (2012-07-17 13:10:38 +0300)

----------------------------------------------------------------
A single rpmsg fix for 3.5, coming from Federico Fuga, which
eliminates the dependency on arbitrary initialization orders.

----------------------------------------------------------------
Federico Fuga (1):
      rpmsg: fix dependency on initialization order

 drivers/rpmsg/virtio_rpmsg_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0KZQPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:15:37 -0500
Received: from smtp.nokia.com ([147.243.128.26]:60185 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0KZQPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:15:36 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Nov 2010 18:16:43 +0200
Message-Id: <20101126161643.25283.96061.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI fixes for 2.6.37-rc
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please UBI fixes for 2.6.37-rcX.

The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

  Linux 2.6.37-rc2 (2010-11-15 18:31:02 -0800)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Dan Carpenter (1):
      UBI: release locks in check_corruption

 drivers/mtd/ubi/scan.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

Thanks,
Artem.

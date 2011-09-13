Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1IMVEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:04:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38055 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1IMVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:04:08 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 0/3] mmc: rectify boot param option for fault injection
Date: Tue, 13 Sep 2011 23:03:27 +0200
Message-Id: <1315947810-22714-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita reported that the boot option for mmc fault injection is never
compiled in due to a fauly "ifdef KERNEL" that is never set.
A correct ifdef would be "ifndef MODULE". Akinobu suggested to use
a module param instead.

This patch set is for 3.2

Per Forlin (3):
  fault-inject: export setup_fault_attr()
  mmc: add module param to set fault injection attributes
  fault-injection: update documenation with the mmc module param

 Documentation/fault-injection/fault-injection.txt |    2 +-
 drivers/mmc/core/debugfs.c                        |   29 ++++++++-------------
 lib/fault-inject.c                                |    3 +-
 3 files changed, 14 insertions(+), 20 deletions(-)

-- 
1.7.4.1


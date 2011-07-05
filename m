Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1GETae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:30:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1GETad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:30:33 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2] documentation of mmc non-blocking request
Date: Tue,  5 Jul 2011 21:30:06 +0200
Message-Id: <1309894208-2197-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes since v1:
 * Minor updates after proofreading comments from Chris

Per Forlin (1):
  mmc: documentation of mmc non-blocking request usage and design.

 Documentation/mmc/00-INDEX          |    2 +
 Documentation/mmc/mmc-async-req.txt |   86 +++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/mmc/mmc-async-req.txt

-- 
1.7.4.1


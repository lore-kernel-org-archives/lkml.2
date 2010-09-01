Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0IAG0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:26:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56413 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0IAG0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mm7a1DZTtRsGXCodV3EzTW2Ko5BxlK+/11mRgCoIcxCwvCvxS4GlHE4AICELJ1b2n+
         a/AjphTjyzbnnymK64U8KShAv3+0zmuN5dIOlUiy+Z2zlMBc2/O6td9xWy9+8V9gSUzN
         1/9zm7HjzxKxxDxSzOFlAeBTcN/dZuE4A8Rjg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 0/3] mmc_test: show test results via sysfs
Date: Wed,  1 Sep 2010 09:26:44 +0300
Message-Id: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a patchset which brings possibility to get test results via sysfs. It
helps to do tests non-interactively.

Andy Shevchenko (3):
  mmc_test: use API to check card type
  mmc_test: change simple_strtol() to strict_strtol()
  mmc_test: collect data and show it via sysfs by demand

 drivers/mmc/card/mmc_test.c |  130 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 122 insertions(+), 8 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967013Ab2EPKXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:23:34 -0400
Received: from skyrme.org ([193.175.80.135]:36904 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966856Ab2EPKXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:23:25 -0400
X-Greylist: delayed 2521 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2012 06:23:25 EDT
Date: 16 May 2012 09:41:15 +0000
Message-Id: <1337161280-28953-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 0/5] Change old mail addresses to current ones
X-Mailer: git-send-email 1.6.0.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several old mail addresses are no longer functional, e.g.:

SMTP error from remote mail server after RCPT TO:<os@emlix.com>:
host 192.168.3.31 [192.168.3.31]: 550 Unknown user

To avoid confusion change to some authors' current addresses.

Oskar Schirmer (5):
  xtensa: Change mail addresses of Hannes Weiner and Oskar Schirmer
  i2c: Change mail address of Oskar Schirmer
  net: Change mail address of Oskar Schirmer
  lib: Change mail address of Oskar Schirmer
  arm/m68k: Change mail address of Sebastian Heß

 arch/m68k/platform/532x/config.c                  |    2 +-
 arch/xtensa/variants/s6000/dmac.c                 |    2 +-
 arch/xtensa/variants/s6000/gpio.c                 |    4 ++--
 arch/xtensa/variants/s6000/include/variant/dmac.h |    2 +-
 arch/xtensa/variants/s6000/irq.c                  |    4 ++--
 drivers/i2c/busses/i2c-s6000.c                    |    2 +-
 drivers/i2c/busses/i2c-s6000.h                    |    2 +-
 drivers/net/ethernet/s6gmac.c                     |    4 ++--
 include/linux/rational.h                          |    2 +-
 lib/rational.c                                    |    2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.7.5.4


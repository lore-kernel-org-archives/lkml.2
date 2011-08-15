Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1HOBL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 21:11:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55305 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751208Ab1HOBL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 21:11:58 -0400
Date: Mon, 15 Aug 2011 10:11:49 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap fixes for 3.1
Message-ID: <20110815011146.GA27355@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-linus

Two small fixes, one stupid cut'n'paste bug which only comes up for the
relatively rare bulk read case and the MODULE_LICENSE() fix from Stephen
to fix modular builds after the last minute flip flopping we had about
where to put the code.

Mark Brown (1):
      regmap: Fix bulk reads

Stephen Warren (1):
      regmap: Specify a module license

 drivers/base/regmap/regmap-i2c.c |    1 +
 drivers/base/regmap/regmap-spi.c |    2 ++
 drivers/base/regmap/regmap.c     |    2 +-
 3 files changed, 4 insertions(+), 1 deletions(-)

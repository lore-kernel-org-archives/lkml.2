Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0FDHrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:47:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36494 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0FDHrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mWqIRCk4mC+lDChtMhwcC0f1qV1krpqCdkP08+HMvWg11YAi4grI1xMCds4lvZkxND
         MPuWGJCyXNTxv5qB3J+3x6Y//N7OTlUpM7wpeCu4uFlx6TLfWpodjjWKfz8nPQ5qWIPR
         bQykqX6O3+QNxVgAp0z4HIKDv2hPswpxYbP1U=
Date: Fri, 4 Jun 2010 00:47:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.35-rc1
Message-ID: <20100604074701.GH21239@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dan Carpenter (1):
      Input: tps6507x-ts - a couple work queue cleanups

Dmitry Torokhov (1):
      Input: ads7846 - fix compiler warning in ads7846_probe()

Mark Brown (2):
      Input: s3c2410_ts - fix build error due to ADC Kconfig rename
      Input: s3c2410_ts - tone down logging

Ping Cheng (1):
      Input: wacom - add Cintiq 21UX2 and Intuos4 WL


Diffstat:
--------

 drivers/input/tablet/wacom_sys.c        |    1 -
 drivers/input/tablet/wacom_wac.c        |   73 +++++++++++++++++++++++++------
 drivers/input/tablet/wacom_wac.h        |    1 +
 drivers/input/touchscreen/Kconfig       |    2 +-
 drivers/input/touchscreen/ads7846.c     |    2 +-
 drivers/input/touchscreen/s3c2410_ts.c  |    2 +-
 drivers/input/touchscreen/tps6507x-ts.c |   12 ++---
 7 files changed, 67 insertions(+), 26 deletions(-)

-- 
Dmitry


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2EEOcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:32:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2EEOcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:18 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 0/8] drivers/staging/line6/ chechpatch.pl cleanups
Date: Sat,  5 May 2012 16:31:44 +0200
Message-Id: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor changes to get rid of some warnings and errors produced by the
checkpatch.pl script

Johannes Thumshirn (8):
  drivers/staging/line6/control.c: Change strict_strtoul to kstrtoul
  drivers/staging/line6/pod.c: Change strict_strtoul to kstrtoul
  drivers/staging/line6/variax.c: Change strict_strtoul to kstrtoul
  drivers/staging/line6/config.h: changed printk(KERN_INFO, ... to
    pr_info(
  drivers/staging/line6/driver.h: Changed printk(KERN_ERR, .. to pr_err
        Changed printk(KERN_ERR, ...) call to pr_err() call in
    MISSING_CASE macro
  drivers/staging/line6/midibuf.c changed printk(KERN_DEBUG, ... to
    pr_debug(
  drivers/staging/line6/midi.c: Added space between switch and open
    parenthesis
  drivers/staging/line6/pcm.c: Removed trailing whitespace

 drivers/staging/line6/config.h  |    2 +-
 drivers/staging/line6/control.c |    2 +-
 drivers/staging/line6/driver.h  |    2 +-
 drivers/staging/line6/midi.c    |    2 +-
 drivers/staging/line6/midibuf.c |    2 +-
 drivers/staging/line6/pcm.c     |    2 +-
 drivers/staging/line6/pod.c     |    6 +++---
 drivers/staging/line6/variax.c  |    8 ++++----
 8 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.7.7.6


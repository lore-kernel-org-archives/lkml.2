Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1GYPxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:53:40 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40493 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1GYPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:53:39 -0400
Date: Mon, 25 Jul 2011 17:53:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for Linux 3.1
Message-ID: <20110725175324.137c340c@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem updates for Linux 3.1 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/busses/i2c-ali1535.c |   61 ++++++++++++++++++-------------------
 drivers/i2c/busses/i2c-cpm.c     |    7 +---
 drivers/i2c/busses/i2c-pxa.c     |    7 +---
 drivers/i2c/busses/i2c-s6000.c   |    5 +--
 drivers/i2c/i2c-core.c           |    5 +++
 5 files changed, 40 insertions(+), 45 deletions(-)

---------------

Grant Likely (1):
      i2c: Allow i2c_add_numbered_adapter() to assign a bus id

LABBE Corentin (1):
      i2c-ali1535: Fix style issues

Thanks,
-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1DQJB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:01:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:16051 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1DQJBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:01:51 -0400
Date: Sun, 17 Apr 2011 11:01:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.39
Message-ID: <20110417110136.71b78b85@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/algos/i2c-algo-bit.c |   22 +++++++++++++++++++---
 drivers/i2c/i2c-core.c           |    6 ++++--
 2 files changed, 23 insertions(+), 5 deletions(-)

---------------

Alex Deucher (1):
      i2c-algo-bit: Call pre/post_xfer for bit_test

Jean Delvare (1):
      i2c: Improve deprecation warnings

Thanks,
-- 
Jean Delvare

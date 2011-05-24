Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1EXV1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:27:11 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47920 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1EXV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:27:09 -0400
Date: Tue, 24 May 2011 23:25:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.40 (or whatever)
Message-ID: <20110524232538.4b2f4b8c@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem updates for Linux 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

Most changes are cleanups and improvements to the Intel 82801 SMBus
controller driver.

 Documentation/i2c/busses/i2c-i801      |    1 +
 Documentation/i2c/writing-clients      |    2 +-
 drivers/i2c/busses/Kconfig             |    2 +
 drivers/i2c/busses/i2c-i801.c          |   61 ++++++++++++++++----------
 drivers/i2c/busses/i2c-parport-light.c |   10 ++--
 drivers/i2c/busses/i2c-parport.c       |   30 ++++++------
 drivers/i2c/busses/i2c-parport.h       |   74 +++++++++++++++-----------------
 7 files changed, 97 insertions(+), 83 deletions(-)

---------------

Jean Delvare (4):
      i2c-i801: Don't probe for slaves on IDF channels
      i2c-i801: Check for vendor Fujitsu before probing for apanel
      i2c-i801: Don't depend on other kernel driver config options
      i2c-parport: Various cleanups

Seth Heasley (1):
      i2c-i801: SMBus patch for Intel Panther Point DeviceIDs

Vikram Narayanan (1):
      i2c/writing-clients: Fix foo_driver.id_table

Thanks,
-- 
Jean Delvare

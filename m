Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0GJHsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 03:48:12 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55400 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0GJHsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 03:48:11 -0400
Date: Sat, 10 Jul 2010 09:48:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.35
Message-ID: <20100710094807.7ee0317c@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.35 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/busses/i2c-sibyte.c |    4 ++--
 drivers/i2c/i2c-core.c          |    7 +++----
 2 files changed, 5 insertions(+), 6 deletions(-)

---------------

Guenter Roeck (1):
      i2c/mips: Fix error return codes from Sibyte i2c bus driver

Jean Delvare (1):
      i2c: Fix probability check

Thanks,
-- 
Jean Delvare

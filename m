Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0EDJMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:12:36 -0400
Received: from bamako.nerim.net ([62.4.17.28]:63459 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab0EDJMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:12:34 -0400
Date: Tue, 4 May 2010 11:12:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.34
Message-ID: <20100504111230.04ffe803@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 Documentation/i2c/writing-clients |    5 +++
 drivers/i2c/i2c-core.c            |   63 +++++++++++++++++++++++-------------
 include/linux/i2c.h               |    2 +
 3 files changed, 47 insertions(+), 23 deletions(-)

---------------

Jean Delvare (2):
      i2c: Fix probing of FSC hardware monitoring chips
      i2c-core: Use per-adapter userspace device lists

Wolfram Sang (1):
      i2c-core: Erase pointer to clientdata on removal

Thanks,
-- 
Jean Delvare

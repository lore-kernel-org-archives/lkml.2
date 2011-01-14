Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1ANVsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:48:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48579 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1ANVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:48:11 -0500
Date: Fri, 14 Jan 2011 22:47:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.38, second round
Message-ID: <20110114224751.2fa55138@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a second round of i2c subsystem updates for Linux 2.6.38
from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/i2c-core.c |   90 ++++++++++++++++++++++--------------------------
 1 files changed, 41 insertions(+), 49 deletions(-)

---------------

Jean Delvare (1):
      i2c: Unregister dummy devices last on adapter removal

Mark Brown (2):
      i2c: Factor out runtime suspend checks from PM operations
      i2c: Encourage move to dev_pm_ops by warning on use of legacy methods

Thanks,
-- 
Jean Delvare

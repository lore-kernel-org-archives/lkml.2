Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab1EAROb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:14:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21347 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab1EARO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:14:26 -0400
Date: Sun, 1 May 2011 19:14:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.39
Message-ID: <20110501191414.7a4a4988@endymion.delvare>
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

 drivers/i2c/busses/i2c-i801.c    |    5 +++++
 drivers/i2c/busses/i2c-parport.c |   27 ++++++++++++++-------------
 include/linux/pci_ids.h          |    4 ----
 3 files changed, 19 insertions(+), 17 deletions(-)

---------------

Jean Delvare (2):
      i2c-i801: Move device ID definitions to driver
      i2c-parport: Fix adapter list handling

Thanks,
-- 
Jean Delvare

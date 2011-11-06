Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1KFTkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:40:02 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46273 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1KFTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:40:00 -0500
Date: Sun, 6 Nov 2011 20:39:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 3.2
Message-ID: <20111106203942.1829bf78@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/coretemp.c  |    3 +--
 drivers/hwmon/w83627ehf.c |    9 ++++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

---------------

Guenter Roeck (1):
      hwmon: (w83627ehf) Fix broken driver init

Jean Delvare (1):
      hwmon: (coretemp) Fix for non-SMP builds

Thanks,
-- 
Jean Delvare

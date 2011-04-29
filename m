Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1D2Pgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:36:39 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2094 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128Ab1D2Pgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:36:37 -0400
Date: Fri, 29 Apr 2011 17:36:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>, rob@curates-egg.org
Subject: [GIT PULL] hwmon fixes for 2.6.39
Message-ID: <20110429173627.11b02646@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 Documentation/hwmon/adm1021 |   36 +++++++++++++++++++-----------------
 Documentation/hwmon/lm90    |   29 ++++++++++++++++++++---------
 drivers/hwmon/Kconfig       |   11 +++++------
 drivers/hwmon/lm85.c        |    6 ++++--
 drivers/hwmon/lm90.c        |   22 +++++++++++++++-------
 5 files changed, 63 insertions(+), 41 deletions(-)

---------------

Guenter Roeck (2):
      hwmon: (lm90) Add support for ADT7461A and NCT1008
      hwmon: (lm90) Fix update interval information in driver documentation

Jean Delvare (3):
      hwmon: (adm1021) Clarify documentation regarding Xeon processors
      hwmon: (lm85) Add missing list terminators
      hwmon: (lm85) Fix error paths in probe function

Thanks,
-- 
Jean Delvare

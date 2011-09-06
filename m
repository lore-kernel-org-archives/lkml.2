Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1IFQPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:15:02 -0400
Received: from imr4.ericy.com ([198.24.6.9]:35515 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1IFQO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:14:56 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.1
Date: Tue, 6 Sep 2011 09:13:28 -0700
Message-ID: <1315325608-17922-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1 from:

    git://github.com/groeck/linux.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
  git://github.com/groeck/linux.git hwmon-for-linus

Guenter Roeck (2):
      hwmon: (max16065) Fix current calculation
      hwmon: (max16065) Add chip access warning to documentation

Jean Delvare (1):
      hwmon: (ucd9000/ucd9200) Optimize array walk

 Documentation/hwmon/max16065  |    7 +++++++
 drivers/hwmon/max16065.c      |    2 +-
 drivers/hwmon/pmbus/ucd9000.c |    6 ++----
 drivers/hwmon/pmbus/ucd9200.c |    6 ++----
 4 files changed, 12 insertions(+), 9 deletions(-)

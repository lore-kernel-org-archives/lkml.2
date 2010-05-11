Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0EKTUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:20:51 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50012 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0EKTUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:20:50 -0400
Date: Tue, 11 May 2010 21:20:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.34
Message-ID: <20100511212047.2fb78fda@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/applesmc.c |   61 ++++++++++++++++++--------------------------
 drivers/hwmon/asc7621.c  |   63 ++++++++++++++++++++++-----------------------
 2 files changed, 56 insertions(+), 68 deletions(-)

---------------

Henrik Rydberg (1):
      hwmon: (applesmc) Correct sysfs fan error handling

Ken Milmore (1):
      hwmon: (asc7621) Bug fixes

Thanks,
-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0C2UPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:15:31 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61360 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0C2UP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:15:28 -0400
Date: Mon, 29 Mar 2010 22:15:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.34
Message-ID: <20100329221525.1706d287@hyperion.delvare>
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

 drivers/hwmon/Kconfig    |    4 ++--
 drivers/hwmon/coretemp.c |    4 ++--
 drivers/hwmon/w83793.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

---------------

Dan Carpenter (1):
      hwmon: (w83793) Saving negative errors in unsigned

Dean Nelson (1):
      hwmon: (coretemp) Add missing newline to dev_warn() message

Jaswinder Singh Rajput (1):
      hwmon: (asc7621) Add X58 entry in Kconfig

Prarit Bhargava (1):
      hwmon: (coretemp) Fix cpu model output

Thanks,
-- 
Jean Delvare

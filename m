Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0CXQs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:48:56 -0400
Received: from bamako.nerim.net ([62.4.17.28]:51768 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab0CXQsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:48:54 -0400
Date: Wed, 24 Mar 2010 17:48:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.34
Message-ID: <20100324174851.3520f920@hyperion.delvare>
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

This brings back SMBus support on some IBM machines.

 drivers/acpi/scan.c           |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-scmi.c |   32 ++++++++++++++++++++++++--------
 include/acpi/acpi_drivers.h   |    2 ++
 3 files changed, 64 insertions(+), 8 deletions(-)

---------------

Crane Cai (1):
      i2c-scmi: Support IBM SMBus CMI devices

Darrick J. Wong (2):
      acpi: Support IBM SMBus CMI devices
      i2c-scmi: Provide module aliases for automatic loading

Thanks,
-- 
Jean Delvare

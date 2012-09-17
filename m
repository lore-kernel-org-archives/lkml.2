Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2IQN7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:59:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34084 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab2IQN6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:58:37 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/7] rtc: convert to c99 format
Date: Mon, 17 Sep 2012 19:28:07 +0530
Message-ID: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series tries to convert the i2c_msg to c99 struct.
This may avoid issues like below if someone tries to add an
element to the structure.
http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
 
Special thanks to Julia Lawall for helping it automate.
By the below script.
http://www.mail-archive.com/cocci@diku.dk/msg02753.html
 

Shubhrajyoti D (7):
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format

 drivers/rtc/rtc-ds1672.c  |   26 ++++++++++++++++++++++----
 drivers/rtc/rtc-em3027.c  |    6 +++---
 drivers/rtc/rtc-isl1208.c |    6 +++---
 drivers/rtc/rtc-pcf8563.c |    4 ++--
 drivers/rtc/rtc-rs5c372.c |    2 +-
 drivers/rtc/rtc-s35390a.c |    4 ++--
 drivers/rtc/rtc-x1205.c   |   28 ++++++++++++++--------------
 7 files changed, 47 insertions(+), 29 deletions(-)

-- 
1.7.5.4


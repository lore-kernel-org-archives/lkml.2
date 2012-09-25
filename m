Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2IYLeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:34:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58150 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab2IYLdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:33:19 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <rtc-linux@googlegroups.com>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        <akpm@linux-foundation.org>, <a.zummo@towertech.it>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 0/7] rtc: convert to c99 format
Date: Tue, 25 Sep 2012 17:01:59 +0530
Message-ID: <1348572726-6940-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series tries to convert the i2c_msg to c99 struct.
This may avoid issues like below if someone tries to add a
structure.
http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html

Special thanks to Julia Lawall for helping it automate.
By the below script.
http://www.mail-archive.com/cocci@diku.dk/msg02753.html
 
Resending with Andrew Morton in cc for review as it was suggested to me.

Fix a typo in the comments that crept in.

Shubhrajyoti D (7):
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format
  rtc: Convert struct i2c_msg initialization to C99 format

 drivers/rtc/rtc-ds1672.c  |   26 +++++++++++--
 drivers/rtc/rtc-em3027.c  |   17 +++++++-
 drivers/rtc/rtc-isl1208.c |   20 ++++++++--
 drivers/rtc/rtc-pcf8563.c |   13 +++++-
 drivers/rtc/rtc-rs5c372.c |    7 +++-
 drivers/rtc/rtc-s35390a.c |   13 +++++-
 drivers/rtc/rtc-x1205.c   |   92 ++++++++++++++++++++++++++++++++++++++-------
 7 files changed, 158 insertions(+), 30 deletions(-)

-- 
1.7.5.4


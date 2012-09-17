Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2IQPXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:23:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40775 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab2IQPW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:22:59 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/6] media: input: convert to c99 format
Date: Mon, 17 Sep 2012 20:52:27 +0530
Message-ID: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
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

Checkpatch warn of more than 80 chars have been ignored.

Shubhrajyoti D (6):
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format

 drivers/media/i2c/ks0127.c                    |    4 ++--
 drivers/media/i2c/msp3400-driver.c            |   12 ++++++------
 drivers/media/i2c/tvaudio.c                   |    4 ++--
 drivers/media/radio/radio-tea5764.c           |    6 +++---
 drivers/media/radio/saa7706h.c                |    4 ++--
 drivers/media/radio/si470x/radio-si470x-i2c.c |   12 ++++++------
 6 files changed, 21 insertions(+), 21 deletions(-)

-- 
1.7.5.4


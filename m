Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2IRMWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:22:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43819 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab2IRMWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:22:51 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv4 0/6] media: convert to c99 format
Date: Tue, 18 Sep 2012 17:52:30 +0530
Message-ID: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
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

Changelogs
- Remove the zero inititialisation of the flags.

Shubhrajyoti D (6):
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format
  media: Convert struct i2c_msg initialization to C99 format

 drivers/media/i2c/ks0127.c                    |   13 +++++++-
 drivers/media/i2c/msp3400-driver.c            |   40 +++++++++++++++++++++----
 drivers/media/i2c/tvaudio.c                   |   13 +++++++-
 drivers/media/radio/radio-tea5764.c           |   13 ++++++--
 drivers/media/radio/saa7706h.c                |   15 ++++++++-
 drivers/media/radio/si470x/radio-si470x-i2c.c |   23 ++++++++++----
 6 files changed, 96 insertions(+), 21 deletions(-)

-- 
1.7.5.4


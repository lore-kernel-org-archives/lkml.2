Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2IQOSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:18:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52589 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab2IQOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:18:20 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/2] input: convert to c99 format
Date: Mon, 17 Sep 2012 19:47:59 +0530
Message-ID: <1347891481-18086-1-git-send-email-shubhrajyoti@ti.com>
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
 

Shubhrajyoti D (2):
  input: Convert struct i2c_msg initialization to C99 format
  input: Convert struct i2c_msg initialization to C99 format

 drivers/input/joystick/as5011.c           |    6 +++---
 drivers/input/touchscreen/cy8ctmg110_ts.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.5.4


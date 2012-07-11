Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab2GKQDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:03:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53029 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab2GKQDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:03:45 -0400
From: Yuri Khan <yurivkhan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Khan <yurivkhan@gmail.com>
Subject: [PATCH 0/1] Input: xpad - Add Andamiro Pump It Up pad
Date: Wed, 11 Jul 2012 23:03:26 +0700
Message-Id: <1342022607-6147-1-git-send-email-yurivkhan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

while I'm at it, I'd like to add my other dance mat to xpad's database 
of known devices, so that the user does not have to specify the 
dpad_to_buttons option.

I couldn't find the vendor ID in any of the online databases, but this 
mat has a Pump It Up logo on the top side of the controller compartment, 
and a disclaimer stating that Andamiro will not be liable on the bottom.

checkpath.pl flagged this patch for adding an overlong line but the 
surrounding code does not adhere to the 80-column rule.

Yuri Khan (1):
  Input: xpad - Add Andamiro Pump It Up pad

 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.9.5


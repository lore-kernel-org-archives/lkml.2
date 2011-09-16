Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1IPGWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:22:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53277 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1IPGWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:22:06 -0400
Date: Thu, 15 Sep 2011 23:22:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.1-rc6
Message-ID: <20110916062200.GA6731@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://github.com/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Axel Lin (2):
      Input: cm109 - fix checking return value of usb_control_msg
      Input: adp5588-keys - remove incorrect modalias

Chris Bagwell (1):
      Input: wacom - fix touch parsing on newer Bamboos

Jason Gerecke (2):
      Input: wacom - advertise BTN_TOOL_PEN and BTN_STYLUS for PenPartner
      Input: wacom - add POINTER and DIRECT device properties

Pieter-Augustijn Van Malleghem (1):
      Input: bcm5974 - add MacBookAir4,1 trackpad support

Ping Cheng (1):
      Input: wacom - remove pressure for touch devices


Diffstat:
--------

 drivers/hid/hid-wacom.c                 |    2 +
 drivers/input/keyboard/adp5588-keys.c   |    1 -
 drivers/input/misc/cm109.c              |    2 +-
 drivers/input/mouse/bcm5974.c           |   20 +++++++++++++
 drivers/input/tablet/wacom_sys.c        |   14 ---------
 drivers/input/tablet/wacom_wac.c        |   45 ++++++++++++++++++++++++-------
 drivers/input/touchscreen/wacom_w8001.c |    2 +
 7 files changed, 60 insertions(+), 26 deletions(-)

-- 
Dmitry


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1IGWbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:31:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab1IGWbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:31:04 -0400
Date: Thu, 8 Sep 2011 00:31:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1109071354200.13109@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://twin.jikos.cz/jikos/hid for-linus

to receive the fixes below.

It contains a few fixes isolated to particular specific drivers, fixing 
behavior of a very limited set of devices.

This pull request is directed to my private server rather than usual 
kernel.org location, for obvious reasons.

Thanks.

Chase Douglas (1):
      HID: magicmouse: Set resolution of touch surfaces

Clemens Werther (1):
      HID: add support for HuiJia USB Gamepad connector

David Herrmann (2):
      HID: wacom: Fix error path of power-supply initialization
      HID: wacom: Unregister sysfs attributes on remove

Jiri Kosina (1):
      HID: magicmouse: ignore 'ivalid report id' while switching modes, v2

 drivers/hid/hid-ids.h           |    1 +
 drivers/hid/hid-magicmouse.c    |   66 ++++++++++++++++++++++++++++++++------
 drivers/hid/hid-wacom.c         |   22 ++++++-------
 drivers/hid/usbhid/hid-quirks.c |    1 +
 4 files changed, 67 insertions(+), 23 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0GJSdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:33:40 -0400
Received: from core.signal11.us ([64.251.29.136]:46867 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0GJSdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:33:38 -0400
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ospite@studenti.unina.it>,
       Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Ott <alan@signal11.us>,
       Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v3 0/1] HID: Add Support for Setting and Getting Feature Reports from hidraw
Date: Sat, 10 Jul 2010 14:33:10 -0400
Message-Id: <1278786791-4025-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275969108-14948-1-git-send-email-alan@signal11.us>
References: <1275969108-14948-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Jul 10 14:33:37 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c38bd01282443219513016
X-DSPAM-Factors: 27,
	To*Michael, 0.01000,
	Received*26+177, 0.01000,
	Cc*<alan, 0.01000,
	To*linux+input, 0.01000,
	the+device, 0.01000,
	To*Ospite+<ospite, 0.01000,
	To*suse.de>, 0.01000,
	10, 0.01000,
	References*git, 0.01000,
	from, 0.01000,
	In-Reply-To*git+send, 0.01000,
	of, 0.01000,
	In-Reply-To*alan, 0.01000,
	c+|, 0.01000,
	c+|, 0.01000,
	References*<1275969108+14948, 0.01000,
	References*alan+signal11.us>, 0.01000,
	Received*ESMTP, 0.01000,
	To*Chatty, 0.01000,
	), 0.01000,
	), 0.01000,
	To*suse.cz>, 0.01000,
	To*troilus.org>, 0.01000,
	Received*(c+76, 0.01000,
	Date*Jul+2010, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	To*usb+vger.kernel.org, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 3 of the patch. Fixing the problem reported by Amit Nagal where
Report IDs were not getting sent to the device when using Set_Report control
tranfers.

Alan Ott (1):
  HID: Add Support for Setting and Getting Feature Reports from hidraw

 drivers/hid/hidraw.c          |  105 +++++++++++++++++++++++++++++++++++++++--
 drivers/hid/usbhid/hid-core.c |   31 ++++++++++--
 include/linux/hid.h           |    3 +
 include/linux/hidraw.h        |    3 +
 4 files changed, 132 insertions(+), 10 deletions(-)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0F3Nuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:50:50 -0400
Received: from core.signal11.us ([64.251.29.136]:48566 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab0F3Nus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:50:48 -0400
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Ott <alan@signal11.us>,
       Marcel Holtmann <marcel@holtmann.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Amit Nagal <helloin.amit@gmail.com>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 0/1] HID: Send Report ID when numbered reports are sent over the control endpoint.
Date: Wed, 30 Jun 2010 09:50:35 -0400
Message-Id: <1277905836-3949-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.LNX.2.00.1006301126130.13809@pobox.suse.cz>
References: <alpine.LNX.2.00.1006301126130.13809@pobox.suse.cz>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jun 30 09:50:48 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c2b4bb8209573463039785
X-DSPAM-Factors: 27,
	reports, 0.01000,
	Received*26+177, 0.01000,
	control+endpoint, 0.01000,
	Cc*<alan, 0.01000,
	To*linux+input, 0.01000,
	To*Ospite+<ospite, 0.01000,
	10, 0.01000,
	the+control, 0.01000,
	c+|, 0.01000,
	Received*ESMTP, 0.01000,
	), 0.01000,
	), 0.01000,
	To*suse.cz>, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	Cc*Ott+<alan, 0.01000,
	files+changed, 0.01000,
	X-Mailer*email, 0.01000,
	From*<alan, 0.01000,
	X-Mailer*git+send, 0.01000,
	To*Holtmann, 0.01000,
	reports+are, 0.01000,
	To*<marcel, 0.01000,
	changed, 0.01000,
	over+the, 0.01000,
	Received*from+localhost.localdomain, 0.01000,
	To*Jiri+Kosina, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch relies on:
  [PATCH 1/1] hidraw: Use Interrupt Endpoint for OUT Transfers if Available

Alan Ott (1):
  HID: Send Report ID when numbered reports are sent over the control
    endpoint.

 drivers/hid/usbhid/hid-core.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)



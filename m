Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2L1TQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:16:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54837 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab2L1TQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:40 -0500
Message-Id: <20121228190330.913310882@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 004/173] HID: hid-magicmouse: Add pointer and buttonpad properties for Magic
 Trackpad
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chase Douglas <chase.douglas@canonical.com>

commit 503f7d53b368c8e4e13a7756220c0536fcf1a034 upstream.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-magicmouse.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 2ab7175..7cf3ffe 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -418,6 +418,8 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 		__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
 		__set_bit(BTN_TOOL_QUADTAP, input->keybit);
 		__set_bit(BTN_TOUCH, input->keybit);
+		__set_bit(INPUT_PROP_POINTER, input->propbit);
+		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 	}
 
 	if (report_touches) {



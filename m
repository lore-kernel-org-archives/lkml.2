Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab2ARLvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:51:24 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:58442 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2ARLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:51:23 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Support of Perixx Peripad 701 for hid-multitouch 
Date: Wed, 18 Jan 2012 12:51:05 +0100
Message-Id: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

This is the v2 of the support of Perixx Peripad 701.

I included the changes asked by Henrik:
- refactor:
+             code = ((usage->hid - 1) & HID_USAGE);
+             code += BTN_MOUSE;
into:
+             code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;

- renamed field maxcontactnumber into maxcontact_report_id
- split the support of the device and the control of the feature Max Contact Number.
- fix typo in commit message

Cheers,
Benjamin


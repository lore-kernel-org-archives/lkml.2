Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2BDQJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:09:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63042 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2BDQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:09:05 -0500
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch v3 0/3] Support of Perixx Peripad 701 for hid-multitouch 
Date: Sat,  4 Feb 2012 17:08:47 +0100
Message-Id: <1328371730-10944-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

This is the v3 of the support of Perixx Peripad 701.

I included the changes asked by Henrik & Dmitry:
-           code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;
+           code =  BTN_MOUSE + ((usage->hid - 1) & HID_USAGE);
use of min;
remove remove the call to input_mt_report_finger_count;
remove debug information;
some cosmetic changes (parenthesis, typos)

Cheers,
Benjamin


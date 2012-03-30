Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab2C3WRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:17:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47677 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935855Ab2C3VNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:13:23 -0400
Message-Id: <20120330194852.451665868@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Keng-Yu Lin <kengyu@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 083/149] HID: add more hotkeys in Asus AIO keyboards
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keng-Yu Lin <kengyu@canonical.com>

commit 6c30d5a53229aad22bb675e0bd6eb518ecaa4316 upstream.

Add support for the camera key. The hotkey for
Asus S.H.E(Super Hybrid Engine) mode is mapped to KEY_KEY_PROG1
just for notifying the userspace.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-chicony.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -49,6 +49,8 @@ static int ch_input_mapping(struct hid_d
 	case 0x00f2: ch_map_key_clear(KEY_BRIGHTNESSDOWN);	break;
 	case 0x00f3: ch_map_key_clear(KEY_BRIGHTNESSUP);	break;
 	case 0x00f4: ch_map_key_clear(KEY_DISPLAY_OFF);	break;
+	case 0x00f7: ch_map_key_clear(KEY_CAMERA);	break;
+	case 0x00f8: ch_map_key_clear(KEY_PROG1);	break;
 	default:
 		return 0;
 	}



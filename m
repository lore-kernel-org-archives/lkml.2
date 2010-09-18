Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0IRTPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:43 -0400
Received: from kroah.org ([198.145.64.141]:43622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976Ab0IRTPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:40 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:04 2010
Message-Id: <20100918191304.025223124@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Eric Piel <eric.piel@tremplin-utc.net>
Subject: [078/129] hp_accel: add quirks for HP ProBook 532x and HP Mini 5102
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4e70598c3b56e6fec551454c495d4d4025834749 upstream.

Added missing axis-mapping for HP ProBook 532x and HP Mini 5102.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/hp_accel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -221,6 +221,8 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HPB442x", "HP ProBook 442", xy_rotated_left),
 	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
+	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
+	AXIS_DMI_MATCH("Mini5102", "HP Mini 5102", xy_rotated_left_usd),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1HNQZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:25:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab1HNQHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.439949493@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [38/90] ALSA: snd-usb-caiaq: Fix keymap for RigKontrol3
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit f4389489b5cbe60b3441869c68bb4afe760969c4 upstream.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Renato <naretobh@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/caiaq/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -30,7 +30,7 @@ static unsigned short keycode_ak1[] =  {
 static unsigned short keycode_rk2[] =  { KEY_1, KEY_2, KEY_3, KEY_4,
 					 KEY_5, KEY_6, KEY_7 };
 static unsigned short keycode_rk3[] =  { KEY_1, KEY_2, KEY_3, KEY_4,
-					 KEY_5, KEY_6, KEY_7, KEY_5, KEY_6 };
+					 KEY_5, KEY_6, KEY_7, KEY_8, KEY_9 };
 
 static unsigned short keycode_kore[] = {
 	KEY_FN_F1,      /* "menu"               */



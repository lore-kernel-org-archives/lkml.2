Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0EQTS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:18:26 -0400
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:37753 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755526Ab0EQTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:18:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=BklnI7H/1QtbByJ+F155ObzxdG7OemlB81ZIfy6iuLGRciJdLJwPvsVED48228uFN4e+V31sVbTYPSR0tsYZefUPtnKEhgSHGAc301b/E0IyRtIN8vHsAjOyz+ZD5IpbXPUUod4n4HBoFtJQ9o200Kv3jXMYwoWqObToax1VM1Q=  ;
X-Yahoo-SMTP: 7VYQSIiswBBpfI3oQQ5mbefGCpOrHbDC5qsO
X-YMail-OSG: YzXKG5AVM1ksUvqGFEiDgOCe.6oXewztcvFYRGN0gIN9uDh
 gDS7Ztp91kQqqwhPv9FlNo82foJyEbIfOS5k2yKd1HLDk14CT5F3QWIpEP1K
 1swM_owwZsWt.0ZLp.8mh3lAzKbJSPw5qJAmcO.0q2TlmAe._RVHPbtyrfAm
 Gve0t9N_27dGBIfyCjTlUvj3KVuPk6WVSTxiAA3M9Bo3s9nmd.Jzf3fXP_u.
 SEUFZCvnAFuuCdDPRQMWjexFWB6VQak2EwTWO_YbOuJjCBwM.OTdAtfVDpuj
 GG6A7iyM2X1U5B6EsbKoJD8FtFVgiAjtu5emVOExCt9LJH6BaUUUweQO_5rn
 ieNKCtTk7Jyr6QHn84HbtPgn8iGokH6qaNYDbxxT.7S8d3P5RXYiKqFb4qjH
 KOX1I9qRDKEeKN8Ekz5cRlkwwEk0rB6itX3VgjIw-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BF1967D.3060404@yahoo.co.uk>
Date: Mon, 17 May 2010 20:18:21 +0100
From: Don Prince <dhprince.devel@yahoo.co.uk>
Reply-To: dhprince.devel@yahoo.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100422 Mandriva/3.0.4-0.4mdv2010.0 (2010.0) Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.34-rc7] HID: remove redundant key mappings from Desktop
 Wireless 6000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 7 redundant key mappings from Desktop Wireless 6000 that are
already handled by the default hid code.

Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>

---

Spotted by by Robert Schedel <r.schedel@yahoo.de>


diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
--- a/drivers/hid/hid-samsung.c	2010-05-17 11:01:26.772377750 +0100
+++ b/drivers/hid/hid-samsung.c	2010-05-17 20:04:36.988502775 +0100
@@ -112,13 +112,6 @@ static int samsung_kbd_mouse_input_mappi
 
 	switch (usage->hid & HID_USAGE) {
 	/* report 2 */
-	case 0x0b5: samsung_kbd_mouse_map_key_clear(KEY_NEXTSONG); break;
-	case 0x0b6: samsung_kbd_mouse_map_key_clear(KEY_PREVIOUSSONG); break;
-	case 0x0b7: samsung_kbd_mouse_map_key_clear(KEY_STOPCD); break;
-	case 0x0cd: samsung_kbd_mouse_map_key_clear(KEY_PLAYPAUSE); break;
-	case 0x0e2: samsung_kbd_mouse_map_key_clear(KEY_MUTE); break;
-	case 0x0e9: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEUP); break;
-	case 0x0ea: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEDOWN); break;
 	case 0x183: samsung_kbd_mouse_map_key_clear(KEY_MEDIA); break;
 	case 0x195: samsung_kbd_mouse_map_key_clear(KEY_EMAIL);	break;
 	case 0x196: samsung_kbd_mouse_map_key_clear(KEY_CALC); break;



	
	
		
___________________________________________________________ 
All new Yahoo! Mail "The new Interface is stunning in its simplicity and ease of use." - PC Magazine 
http://uk.docs.yahoo.com/nowyoucan.html

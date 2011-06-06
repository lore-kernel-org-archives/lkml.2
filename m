Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1FFQMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:12:17 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:39364 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab1FFQMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KVk8FhlRCkRAK8eJj8RzrKfzWGB/S9/GUgCj1JMcVYbJcuIGujOeU8ZVEf3qiyzhXk
         vFqaL3CLPratD98FFZLV+U/UnIa+6AS5+UHEbe2JSMY73oTGEV4q3uo/RR2l+wgOL623
         V9PFa09QF8ZhKSCfLDGUYjn5Qu6wgObmavEcE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:media:dvb:frontends:s5h1420.c Change: clock_settting to clock_setting
Date: Mon,  6 Jun 2011 09:11:52 -0700
Message-Id: <1307376712-3283-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch, changes clock_settting to clock_setting. 
Note: This could be intentionally set this way from the beginning and/or is a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/dvb/frontends/s5h1420.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 17f8cdf..3879d2e 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -634,7 +634,7 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	struct s5h1420_state* state = fe->demodulator_priv;
 	int frequency_delta;
 	struct dvb_frontend_tune_settings fesettings;
-	uint8_t clock_settting;
+	uint8_t clock_setting;
 
 	dprintk("enter %s\n", __func__);
 
@@ -684,19 +684,19 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	switch (state->fclk) {
 	default:
 	case 88000000:
-		clock_settting = 80;
+		clock_setting = 80;
 		break;
 	case 86000000:
-		clock_settting = 78;
+		clock_setting = 78;
 		break;
 	case 80000000:
-		clock_settting = 72;
+		clock_setting = 72;
 		break;
 	case 59000000:
-		clock_settting = 51;
+		clock_setting = 51;
 		break;
 	case 44000000:
-		clock_settting = 36;
+		clock_setting = 36;
 		break;
 	}
 	dprintk("pll01: %d, ToneFreq: %d\n", state->fclk/1000000 - 8, (state->fclk + (TONE_FREQ * 32) - 1) / (TONE_FREQ * 32));
-- 
1.7.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2L1UAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:00:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194Ab2L1TQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:50 -0500
Message-Id: <20121228190334.014647549@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Masanari Iida <standby24x7@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 019/173] drivers/leds/leds-lp5521.c: fix typo
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masanari Iida <standby24x7@gmail.com>

commit 3a2fd4a14112452eb5c1a079ac8b3f4842762afe upstream.

"reseting" -> "resetting"

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index d62a798..c42c8f0 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -694,7 +694,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 */
 	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev, "error in reseting chip\n");
+		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
 	usleep_range(10000, 20000);



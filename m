Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0GAUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:52:25 -0400
Received: from kroah.org ([198.145.64.141]:47721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767Ab0GAUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:50 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:35 2010
Message-Id: <20100701173435.392436029@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Homuth-Rosemann <homuth-rosemann@gmx.net>
Subject: [patch 102/164] Staging: comedi - correct parameter gainlkup for DAQCard-6024E in driver ni_mio_cs.c
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Homuth-Rosemann <homuth-rosemann@gmx.net>

commit ebe8622342f12bed387f7de4b5fb7c52005ccb29 upstream.

Correct at least one of the incorrect specs for a national instrument
data acquisition card DAQCard-6024E. This card has only four different
gain settings (+-10V, +-5V, +-0.5V, +-0.05V).

Signed-off-by: Martin Homuth-Rosemann <homuth-rosemann@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/ni_mio_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -123,7 +123,7 @@ static const struct ni_board_struct ni_b
 	 .adbits = 12,
 	 .ai_fifo_depth = 1024,
 	 .alwaysdither = 0,
-	 .gainlkup = ai_gain_16,
+	 .gainlkup = ai_gain_4,
 	 .ai_speed = 5000,
 	 .n_aochan = 2,
 	 .aobits = 12,



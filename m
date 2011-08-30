Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab1H3ER6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:17:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1H3ER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:17:57 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 01/18] Staging: cx25821: Get rid of typedef in cx25821.h
Date: Tue, 30 Aug 2011 12:16:56 +0800
Message-Id: <1314677833-4689-2-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of typedef in cx25821.h

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 6230243..a282592 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -179,15 +179,17 @@ struct cx25821_input {
 	u32 gpio0, gpio1, gpio2, gpio3;
 };
 
-typedef enum {
+enum port {
 	CX25821_UNDEFINED = 0,
 	CX25821_RAW,
 	CX25821_264
-} port_t;
+};
 
 struct cx25821_board {
 	char *name;
-	port_t porta, portb, portc;
+	enum port porta;
+	enum port portb;
+	enum port portc;
 	unsigned int tuner_type;
 	unsigned int radio_type;
 	unsigned char tuner_addr;
-- 
1.7.0.4


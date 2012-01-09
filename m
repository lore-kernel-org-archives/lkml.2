Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab2AITZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:25:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053Ab2AITZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:25:30 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jesper Juhl <jj@chaosbits.net>, Jesper Juhl <jj@codesealer.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/8] BMP085: Remove redundant semi-colon from return statement
Date: Mon,  9 Jan 2012 11:25:04 -0800
Message-Id: <1326137105-9960-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326137105-9960-1-git-send-email-gregkh@suse.de>
References: <20120109190736.GA9440@kroah.com>
 <1326137105-9960-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

Just a single ";" will do nicely.

Signed-off-by: Jesper Juhl <jj@codesealer.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/bmp085.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 5f898cb..b29a2be 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -216,7 +216,7 @@ static s32 bmp085_get_temperature(struct bmp085_data *data, int *temperature)
 		*temperature = (x1+x2+8) >> 4;
 
 exit:
-	return status;;
+	return status;
 }
 
 /*
-- 
1.7.8


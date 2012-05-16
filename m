Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2EPMo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:44:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34312 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab2EPMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:44:27 -0400
Date: Wed, 16 May 2012 05:42:57 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/6] persistent_ram: Remove never used struct
 persistent_ram_zone members
Message-ID: <20120516124256.GA18345@lizard>
References: <20120516124109.GA14658@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516124109.GA14658@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 'old_log_footer_size' and 'early' members of struct
persistent_ram_zone, as these were never used at all.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
index d3b2b45..d23850c 100644
--- a/drivers/staging/android/persistent_ram.h
+++ b/drivers/staging/android/persistent_ram.h
@@ -59,8 +59,6 @@ struct persistent_ram_zone {
 
 	char *old_log;
 	size_t old_log_size;
-	size_t old_log_footer_size;
-	bool early;
 };
 
 int persistent_ram_early_init(struct persistent_ram *ram);
-- 
1.7.9.2


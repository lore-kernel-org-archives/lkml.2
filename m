Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0IBVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:09:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51384 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0IBVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Yad5vZeenh0MveLRnMeZ4NTjrhVqWq3/imiVmGM4vWkaKabLYAYvSNmNCVNKJ4vMmM
         FRulkKN37kBg9z+1nFGKagbsHOex73+fw+Im1foV+BFK/rg/WyWX90ShYhwSyREAgSsH
         Bf8Q7hexP/AdF7KwDZMYY1jy4H7bOoS/btEmo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 37/91] arch/m68k/mac/via.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:58 -0700
Message-Id: <1283461746-7905-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
References: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/mac/via.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index e71166d..0cfa2cf 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -6,11 +6,8 @@
  *
  * CSA: Motorola seems to have removed documentation on the 6522 from
  * their web site; try
- *     http://nerini.drf.com/vectrex/other/text/chips/6522/
- *     http://www.zymurgy.net/classic/vic20/vicdet1.htm
- * and
- *     http://193.23.168.87/mikro_laborversuche/via_iobaustein/via6522_1.html
- * for info.  A full-text web search on 6522 AND VIA will probably also
+ *     http://web.archive.org/web/*/http://www.zymurgy.net/classic/vic20/vicdet1.htm
+ * A full-text web search on 6522 AND VIA will probably also
  * net some usefulness. <cananian@alumni.princeton.edu> 20apr1999
  *
  * Additional data is here (the SY6522 was used in the Mac II etc):
-- 
1.7.2.1


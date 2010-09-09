Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab0IIWYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab0IIWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y85jBA4Q+aVoFJs3sYJ5ugyqAAiIWMDguJqlsNZBh97o6OW/q7hJjZyItFlPIzO80E
         pqBADZiCnNbHdVMHv4cHy62yGn/7885fRpHMU+qiwwzE9dbpyjGqa27TC8bg5qjzAE3R
         vGny08rSZ5u0AxWyx8ppbrqVXh5/ISpa1vkvg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 009/223]drivers/char/agp/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:45 -0700
Message-Id: <1284071091-7676-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/agp/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 4b66c69..c8ad619 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -34,7 +34,7 @@ config AGP_ALI
 	  X on the following ALi chipsets.  The supported chipsets
 	  include M1541, M1621, M1631, M1632, M1641,M1647,and M1651.
 	  For the ALi-chipset question, ALi suggests you refer to
-	  <http://www.ali.com.tw/eng/support/index.shtml>.
+	  <http://www.ali.com.tw/>.
 
 	  The M1541 chipset can do AGP 1x and 2x, but note that there is an
 	  acknowledged incompatibility with Matrox G200 cards. Due to
-- 
1.7.2.1


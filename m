Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0IIW1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:27:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab0IIW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aKckfK5k7Kr9rQUDNbu2gs8huRmx3eBKz6Wb5wQaRHrhpxDfYKQUOaocT9mpyTFQSq
         NUljim2wNTZk8ovbNFDtBOJDh86ph3KPzC+bpqulwIW0doPtj6pierZkUFfmr4jB3nJw
         RP711pQAI+wYNFZEv1B8LlOFd2hBwCcIg9PzU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 052/223]drivers/media/video/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:35 -0700
Message-Id: <1284071263-7789-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
References: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f6e4d04..0f669ee 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -978,7 +978,7 @@ config USB_STKWEBCAM
 	  Supported devices are typically found in some Asus laptops,
 	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
 	  may be supported by the stk11xx driver, from which this is
-	  derived, see http://stk11xx.sourceforge.net
+	  derived, see http://sourceforge.net/projects/syntekdriver/ 
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called stkwebcam.
-- 
1.7.2.1


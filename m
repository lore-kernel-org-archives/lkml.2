Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab0IIWoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:44:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab0IIWoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cZHTcvxEJ8y7lRNk8jw3Sp0mNPmPH1J1PGzhN2j1IIIQrS9behPhrbBdjkOL+laIW1
         Q7FsydK+oBVjeVWGp4PEQSDTYPjB+/iZJcO5Ij/HCGex15N7B/RU9bMesJQQb0vTFde/
         3R91dzQV/oUtuxQOS81pxUMwmPXiUbXIWdb20=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 190/223]drivers/staging/comedi/drivers/pcl711.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:44:08 -0700
Message-Id: <1284072253-8390-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
References: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/comedi/drivers/pcl711.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index b44386a..b86dda1 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -41,7 +41,7 @@ supported.
    driver for the PCL-711.  I used a few ideas from his driver
    here.  His driver also has more comments, if you are
    interested in understanding how this driver works.
-   http://tech.buffalostate.edu/~dave/driver/
+   http://web.archive.org/web/*/http://tech.buffalostate.edu/~dave/driver/ 
 
    The ACL-8112 driver was hacked from the sources of the PCL-711
    driver (the 744 chip used on the 8112 is almost the same as
-- 
1.7.2.1


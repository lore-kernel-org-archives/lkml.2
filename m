Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1AURnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:43:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51907 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab1AURni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=SDagnalo6YETBOU7lC9LBSvktUm6MazjXzib+IdbZyip75UbFpzcItuOKiIyC76h/e
         AeqJTZxHqitwd2la3L5imIuDG4tz5/YIdc07iSKvnhdESXUlZjqNuFc+DUNOlQm7znIP
         zbGZ4gg2dJ4GmyLyedtFFaa4YjKexWF+q/VyU=
MIME-Version: 1.0
Date: Fri, 21 Jan 2011 23:13:37 +0530
Message-ID: <AANLkTimS=EqyZSxCr-Xi4DDAKsOuMYKh+KcdEaE3nDKc@mail.gmail.com>
Subject: [PATCH 2.6.37] edac: i82975x author/maintainer email address change
From: Arvind R <arvino55@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2.6.37] edac: i82975x author/maintainer email address change

edac-i82975x author/maintainer email address change

Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 MAINTAINERS                 |    2 +-
 drivers/edac/i82975x_edac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---
diff -u a/MAINTAINERS b/MAINTAINERS
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2229,7 +2229,7 @@

 EDAC-I82975X
 M:	Ranganathan Desikan <ravi@jetztechnologies.com>
-M:	"Arvind R." <arvind@jetztechnologies.com>
+M:	"Arvind R." <arvino55@gmail.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
diff -u a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -664,7 +664,7 @@ module_init(i82975x_init);
 module_exit(i82975x_exit);

 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arvind R. <arvind@acarlab.com>");
+MODULE_AUTHOR("Arvind R. <arvino55@gmail.com>");
 MODULE_DESCRIPTION("MC support for Intel 82975 memory hub controllers");

 module_param(edac_op_state, int, 0444);

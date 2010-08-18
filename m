Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0HRQKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:10:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55552 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0HRQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=LgqKHP+8Z7712koc50u/gEy/5oQyaZoVcjemfHG7UtSstK6BLAQbcNjQrV2D6ecXBC
         6ksxM0rzSU4V2kr6mYZTNXPqpJVY+QXzOWxCmXIJImUFtKf7GWAX16VfeMoPZpmluihT
         BHOkZQKsbUQw2wBZbMEvo1oBSZbHaR+EnRq08=
MIME-Version: 1.0
Date: Wed, 18 Aug 2010 12:10:39 -0400
Message-ID: <AANLkTimKR7knyqC9JxqvUkp1v7LtUqOjWnrAExPx49-P@mail.gmail.com>
Subject: [PATCH] powerpc: 2.6.35.2 won't build "uImage" target
From: "Matthew L. Creech" <mlcreech@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm assuming it's just a typo, but commit
afaac2588bac3673e5e1c6b73fc054c931535175 renames the "uImage" target
to "uImaged", which breaks my ppc build.  Trivial fix included.

Signed-off-by: Matt Creech <mlcreech@gmail.com>
---
arch/powerpc/Makefile |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -purN orig/arch/powerpc/Makefile linux-2.6.35.2/arch/powerpc/Makefile
--- orig/arch/powerpc/Makefile  2010-08-18 12:02:15.766054443 -0400
+++ linux-2.6.35.2/arch/powerpc/Makefile        2010-08-18
12:02:32.025501666 -0400
@@ -164,7 +164,7 @@ drivers-$(CONFIG_OPROFILE)  += arch/power
 all: zImage

 # With make 3.82 we cannot mix normal and wildcard targets
-BOOT_TARGETS1 := zImage zImage.initrd uImaged
+BOOT_TARGETS1 := zImage zImage.initrd uImage
 BOOT_TARGETS2 := zImage% dtbImage% treeImage.% cuImage.% simpleImage.%

 PHONY += $(BOOT_TARGETS1) $(BOOT_TARGETS2)

-- 
Matthew L. Creech

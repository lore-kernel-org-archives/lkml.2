Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0FOIGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:06:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54655 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0FOIGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jrJ4jskLWxgAUr+tWEIfkeL+FGP+JFjdpAU36roRaotOLF7sY9ZpdmjwYg1sOrUq70
         1NUQTJhHKiNp7gpNjbUg2bhP7XLDqEQucS1VsouKJiNefbiP0a4WZZYkb71bQm8qaWs0
         qvIsfo1KGSxts5G/R+9/6+FJti0MhQrgLFIFM=
MIME-Version: 1.0
Date: Tue, 15 Jun 2010 16:06:16 +0800
Message-ID: <AANLkTikziSEDW07YiiJs6ny6JLhSQ-TGvdw_kTroIIx5@mail.gmail.com>
Subject: [PATCH] um: Include missing header file in os-linux/mem.c
From: Liu Aleaxander <aleaxander@gmail.com>
To: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The os-linux/mem.c file calls fchmod function, which is declared in sys/stat.h
header file, so include it.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 arch/um/os-Linux/mem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 93a11d7..e696144 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -10,6 +10,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <string.h>
+#include <sys/stat.h>
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "init.h"


-- 
Thanks & regards
Liu Aleaxander

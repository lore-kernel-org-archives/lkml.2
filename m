Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0GNSCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:02:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38934 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab0GNSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jwFtquRpwiwUVM5YBNRnEjSmP6FdYF/FCeFXHKl76umpaOFbjetWhNKoaBH902MxfA
         WRpgYieuk76hmqosZlw5gdMP1riAKQQJLLiGRrEBkUASEaPEBlJnUbkUhNCfRVTPn/IU
         1qLE8iDD7wRkYCTxKbgwz5KLm4WOWD73+t0Yc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Chris Dearman <chris@mips.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] arch/mips/kernel/smtc.c: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:01:42 +0400
Message-Id: <1279130502-10777-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/mips/kernel/smtc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index a95dea5..cfeb2c1 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -975,8 +975,7 @@ void ipi_decode(struct smtc_ipi *pipi)
 			ipi_call_interrupt();
 			break;
 		default:
-			printk("Impossible SMTC IPI Argument 0x%x\n",
-				(int)arg_copy);
+			printk("Impossible SMTC IPI Argument %p\n", arg_copy);
 			break;
 		}
 		break;
-- 
1.7.0.4


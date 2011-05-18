Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab1EROdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:33:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44352 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab1EROdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=H3QVgYZBFvpwMpZAeyddIp5JKdKHD9j2XtCswncoznrcEQOGA49ax5U8vp3jaHdL6x
         T98g5BDnl63DT/NGgElYEbMhOm3CNtPvAQ2DK3H0bfCXrjehaJ/yF3p+tajId9l6H1I0
         sNcDEC6EpfK+3nFx/KrlFvcJj2a7XdLdVM4aY=
MIME-Version: 1.0
Date: Wed, 18 May 2011 15:33:29 +0100
Message-ID: <BANLkTim5JJeXYqBfoGLBD5=ZTn9cF9-zug@mail.gmail.com>
Subject: [PATCH] pata_marvell: Add support for 88SE91A0, 88SE91A4
From: =?UTF-8?Q?Pawe=C5=82_Drewniak?= <czajernia@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch enables support for Marvell IDE PATA controllers found on
Asus P8P67LE motherboard.

--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -161,6 +161,8 @@
       { PCI_DEVICE(0x11AB, 0x6121), },
       { PCI_DEVICE(0x11AB, 0x6123), },
       { PCI_DEVICE(0x11AB, 0x6145), },
+       { PCI_DEVICE(0x1B4B, 0x91A0), },
+       { PCI_DEVICE(0x1B4B, 0x91A4), },
       { }     /* terminate list */
 };

Thanks,
Paweł Drewniak

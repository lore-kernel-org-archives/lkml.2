Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0GXVMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 17:12:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60209 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0GXVMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 17:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=u+U7CSgbRAcsZUqAHmJg29oTgfWipxemw2CJa/oIwpRrjCuBUjckwruF62v2QKgQ7u
         nUzJ6VnWoXUo1ESCfva5NvcAHmeAldXR0S4lG43HiZwGIDsdZJfW4TsLbzA1RRwHOf4V
         sAIQcv0Ercv+vJAyaSESv/5TKlzx1RooKuTys=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Elizalde?= <elizalde.andres@gmail.com>
Date: Sat, 24 Jul 2010 18:12:33 -0300
Message-ID: <AANLkTinYj34Bv0HRgoVP=QFF=-0CFXPYPv3GJ_FQ=BhQ@mail.gmail.com>
Subject: [PATCH FOR 2.6.34] Update for saa7134 driver. Radio support for 
	ENLTV-FM53
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix radio support for card Encore ENLTV-FM v5.3

--- linux/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-07-24
17:28:30.000000000 -0300
+++ linux/drivers/media/video/saa7134/saa7134-cards.c	2010-07-24
17:25:15.000000000 -0300
@@ -3651,7 +3651,7 @@ struct saa7134_board saa7134_boards[] =
 		.radio = {
 			.name = name_radio,
 			.vmux = 1,
-			.amux = LINE2,
+			.amux = 1,
 		},
 		.mute = {
 			.name = name_mute,

Signed-off-by: Elizalde Andrés <elizalde.andres@gmail.com>

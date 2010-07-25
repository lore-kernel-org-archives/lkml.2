Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab0GYG01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 02:26:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64949 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab0GYG0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 02:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sk5ecPWuns4qYmuE2Wglz7qdxvsAvg1UZaqQhQMia1MEuTuR8eQrbDXgWE5p4hx6O4
         os42R1ZdtCXjOd9RzIItE2Tsx4tnAWl+OwIj45PX4QX0xCiAciXbr0spAprLgq4enhng
         IdpevTJaQBGfo22nkSAFesadtwqm39d0PL5FY=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Elizalde?= <elizalde.andres@gmail.com>
Date: Sun, 25 Jul 2010 03:26:02 -0300
Message-ID: <AANLkTin1h6vURtLOY3QdxqgK-Wv1fAUqh7sZzFuaD7vY@mail.gmail.com>
Subject: [PATCH] Update for saa7134 driver. Radio support for ENLTV-FM53
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix radio support for Encore ENLTV-FM v5.3 card

--- linux/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-07-24
18:21:30.000000000 -0300
+++ linux/drivers/media/video/saa7134/saa7134-cards.c	2010-07-24
18:21:44.000000000 -0300
@@ -3651,7 +3651,7 @@ struct saa7134_board saa7134_boards[] =
 		.radio = {
 			.name = name_radio,
 			.vmux = 1,
-			.amux = 1,
+			.amux = LINE2,
 		},
 		.mute = {
 			.name = name_mute,

Signed-off-by: Elizalde Andrés <elizalde.andres@gmail.com>

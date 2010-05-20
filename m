Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0ETB4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:56:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62991 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0ETB4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=s79PIL1ftL6wPjh6+acz/TdUULbmguD/2OB0PRSdQVsUsxIuQeHiik3kqF4bAy6i2d
         PUYQXhlWLt9eUv51+GjMfdxTjFDVKvjZiSH4i3rHYO+a+hb6ALrpC/PPIXjV78k43hIF
         RpCs/oUeUfo55fj9FdV7EBESuTbisNIeiP8sA=
MIME-Version: 1.0
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 20 May 2010 09:56:25 +0800
Message-ID: <AANLkTilhnzVtLsWqyllH5vhFIwDaUKllnkfxSyqKC6hv@mail.gmail.com>
Subject: Comments of fbcon_cw.c made a mistake
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

Recently I'm reading linux kernel and I've found this tiny problem.

    The comment at top of fbcon_cw.c annonced it is fbcon_ud.c.

I'm strongly interested in linux kernel and wish to learn the
community. Although this problem is really not a big deal, but maybe
it's a good start, good chance to learn.

If I did anything unregular, please tell me. Thank you.

Here is my patch:

diff --git a/drivers/video/console/fbcon_cw.c b/drivers/video/console/fbcon_cw.c
index 126110f..2f51a51 100644
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -1,5 +1,5 @@
/*
- *  linux/drivers/video/console/fbcon_ud.c -- Software Rotation - 90 degrees
+ *  linux/drivers/video/console/fbcon_cw.c -- Software Rotation - 90 degrees
 *
 *      Copyright (C) 2005 Antonino Daplas <adaplas @pol.net>
 *

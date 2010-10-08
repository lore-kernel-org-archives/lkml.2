Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0JHL6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 07:58:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50326 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0JHL6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 07:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=EMCHdtj8dBk6tb0xJF3f4tfFPmza1HlS0vj7WKC13Yex/o1WUb18cWIO6vGe12y2Ju
         ZRyFhupKF4+/3e5oKsY7f76TzrnyWIav0mB3d8phkl06jmPc8jgD7VfsDPYy5/nJaWao
         hwwyztyD/Q7+JIevTWa0s/Ov0firBfHl3p/9g=
MIME-Version: 1.0
From: dave b <db.pub.mail@gmail.com>
Date: Fri, 8 Oct 2010 22:58:27 +1100
Message-ID: <AANLkTik9yFPpX55KSRt3y3LwEGHpAQafgKj5kKgUObm1@mail.gmail.com>
Subject: [PATCH] minor spelling fix up to the documentation in drivers/md/dm-crypt.c
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -Nurp drivers/md/dm-crypt.c.orig drivers/md/dm-crypt.c
--- drivers/md/dm-crypt.c.orig	2010-10-08 22:53:08.000000000 +1100
+++ drivers/md/dm-crypt.c	2010-10-08 22:53:57.000000000 +1100
@@ -97,7 +97,7 @@ struct crypt_config {

 	/*
 	 * pool for per bio private data, crypto requests and
-	 * encryption requeusts/buffer pages
+	 * encryption requests/buffer pages
 	 */
 	mempool_t *io_pool;
 	mempool_t *req_pool;

Signed-off-by: dave bl <db.pub.mail@gmail.com>

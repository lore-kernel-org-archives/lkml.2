Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0CYRXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:24 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab0CYRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=P1EMPicEiILfstDOOutAWObbq5sX55tgEPIyY+yvG3FazMhtSX5/9e4zXlj4riQuNq
         /Ciup6dayKw52/dfT318FdRYse/hCmTIEHLRFsVDx99JgLBvqFuDXilXgljrl1wtmF59
         65PzmedVTHYeZA4Dx4VDbq29ZBY1V8pgJkSmg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jonathan Cameron <jic23@cam.ac.uk>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] Staging: iio: Documentation/lis3l02dqbuffersimple.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:37 +0100
Message-Id: <1269537767-7553-7-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c: dirent.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 .../iio/Documentation/lis3l02dqbuffersimple.c      |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
index 2b5cfc5..6a8fa0c 100644
--- a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
+++ b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
@@ -19,7 +19,6 @@
 #include <sys/dir.h>
 
 #include <linux/types.h>
-#include <dirent.h>
 #include "iio_util.h"
 
 static const char *ring_access = "/dev/iio/lis3l02dq_ring_access";
-- 
1.7.0.3.296.g9776a


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab0JZIo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:44:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0JZIo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qmrBDntePcKpyaRK0y71gpv9YL1NcdMYWHssMuc62LUvf7VE+Qojk/y4PAaSsUmCGA
         dzP0FBmwRwGlzShjWjq2lVES03dz/H9G6tVzbx6GBbtJ/m2WU6xHi+DFxGuZr62+xNkH
         Ur8HG9j5TRVfOFRv7/Hp4UGHgP8fZdAv022Xw=
MIME-Version: 1.0
Date: Tue, 26 Oct 2010 16:44:57 +0800
Message-ID: <AANLkTi=N__M=Deb70jRb1_G-MZpTVYuroic1m9C=_A8n@mail.gmail.com>
Subject: [PATCH] pid: remove unused include
From: jovi zhang <bookjovi@gmail.com>
To: akpm@linux-foundation.org, andre.goddard@gmail.com, josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I forget re-send the new patch.

remove unused include

Signed-off-by: bookjovi@gmail.com
kernel/pid.c |    1 -
1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 39b65b6..5e8e8c6 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -35,7 +35,6 @@
#include <linux/hash.h>
#include <linux/pid_namespace.h>
#include <linux/init_task.h>
-#include <linux/syscalls.h>

#define pid_hashfn(nr, ns)     \
       hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)

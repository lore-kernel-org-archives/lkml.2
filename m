Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0JELU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:20:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0JELU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w4RJuC7TvdBzZQyEhgK/Yp2GrNwuUw9HegoyVoFTTuOYLYm/9pLn/Ck6nYfJ/CPjKY
         sC1MpiwOfoGW2zE2Z3ZP4tpWhHVDHRJoXwbcgVRz77LtSn1ggWTEuHhfnLYTjG+UNPj3
         iv6h0FuRHDVCoyghN26sfRkXgKeWgAhmk4WsM=
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 19:20:26 +0800
Message-ID: <AANLkTikcRppGD592yth-xaea961OczDhXX1Hj+qQ6fJH@mail.gmail.com>
Subject: [PATCH] pid: remove unused include
From: jovi zhang <bookjovi@gmail.com>
To: andre.goddard@gmail.com, hedi@sgi.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unused include of pid.c

Signed-off-by: jovi zhang <bookjovi@gmail.com>
kernel/pid.c |    3 ---
1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index d55c6fb..6de4c07 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -27,15 +27,12 @@
 */

#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/slab.h>
#include <linux/init.h>
#include <linux/rculist.h>
#include <linux/bootmem.h>
#include <linux/hash.h>
#include <linux/pid_namespace.h>
#include <linux/init_task.h>
-#include <linux/syscalls.h>

#define pid_hashfn(nr, ns)     \
       hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)

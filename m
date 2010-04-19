Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab0DSETY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 00:19:24 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:52739 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0DSETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 00:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=i8WIfFbdDO8x+ewcB/pbB35DE5RmkazDSuQpF7sWvxFT/qqG3dzBxnlwb7nHBd+/jv
         hqefQGJtso46l2nEWzVvViNhjZii6W0nUZ95vpUoKc+ZgqsZLy2M9BFSK0gqZtqYE6Ef
         NQqOkoNe8kD5HxW1tVueBeCDjDzmVfG2ql4VM=
MIME-Version: 1.0
Date: Sun, 18 Apr 2010 21:19:19 -0700
Message-ID: <i2ydd18b0c31004182119w30322238p2ab0094f55901051@mail.gmail.com>
Subject: gcc- 4.6.0 20100416 rtmutex.c:1138:1: internal compiler error
From: Justin Mattock <justinmattock@gmail.com>
To: gcc@gcc.gnu.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so far I've compiled most of the system
(glibc,Xserver,etc..)
and not really anything has crashed and burned
except for the kernel:

kernel/rtmutex.c: At top level:
kernel/rtmutex.c:1138:1: internal compiler error: in
cgraph_decide_inlining_of_small_functions, at ipa-inline.c:1009
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[1]: *** [kernel/rtmutex.o] Error 1
make: *** [kernel] Error 2

any reports of this/ideas?

-- 
Justin P. Mattock

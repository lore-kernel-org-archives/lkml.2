Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0D0UGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:06:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:4449 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0D0UF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=L4BqjYYFX1wFhDaO3V2wdpNBB8Ioi0uNvcltMrJ7Pqmuv4JvI5eUG4DHTJ9HWnyWyz
         A46R+NP81it7wvvAUzsvfSWFsIeaR7PL/bTCZLKjpyj1wJm9gifB/tJvQzZDpjgDm43m
         Q23Pyeaw17yHikb6rpsCT0cAhLKWgqIU593Ns=
Date: Tue, 27 Apr 2010 22:05:38 +0200 (CEST)
From: John Kacur <jkacur@gmail.com>
X-X-Sender: jkacur@localhost
To: Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
cc: jstultz@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: 2.6.33.3-rt16 compile failure in fs/ecryptfs/inode.o
Message-ID: <alpine.LFD.2.00.1004272202250.3318@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2008694044-1272398755=:3318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2008694044-1272398755=:3318
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT


make O=/bld/2.6.33.3-rt16/ fs/ecryptfs/inode.o
  Using /home/jkacur/jk-2.6 as source for kernel
  GEN     /bld/2.6.33.3-rt16/Makefile
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    /home/jkacur/jk-2.6/scripts/checksyscalls.sh
  CC [M]  fs/ecryptfs/inode.o
/home/jkacur/jk-2.6/fs/ecryptfs/inode.c: In function 
¡ecryptfs_lookup_and_interpose_lower¢:
/home/jkacur/jk-2.6/fs/ecryptfs/inode.c:266: error: wrong type argument to 
unary exclamation mark
make[2]: *** [fs/ecryptfs/inode.o] Error 1
make[1]: *** [fs/ecryptfs/inode.o] Error 2
make: *** [sub-make] Error 2

The above comes from: 
commit 5c0eb5cec064ce26ffcd0cdd684c9b6dd7c9074e
Author: Nick Piggin <npiggin@suse.de>
Date:   Fri Jan 29 15:38:21 2010 -0800

    fs-dcache-scale-d_count

--8323328-2008694044-1272398755=:3318--

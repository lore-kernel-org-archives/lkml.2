Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab0FDDKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:10:34 -0400
Received: from clueserver.org ([65.102.45.174]:36505 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0FDDKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:10:31 -0400
Date: Thu, 3 Jun 2010 20:10:30 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: linux-kernel@vger.kernel.org
Subject: Additional info on modpost segfault
Message-ID: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed adding the actual segfault message:

   LD      drivers/usb/built-in.o
   LD      drivers/built-in.o
   LD      vmlinux.o
   MODPOST vmlinux.o
/bin/sh: line 1: 20665 Segmentation fault      (core dumped) 
scripts/mod/modpost -o 
/home/alan/GitTrees/linux-2.6-mid-ref/Module.symvers -S vmlinux.o
make[1]: *** [vmlinux.o] Error 139
make: *** [vmlinux.o] Error 2

I have looked at the gcc 4.4.4 changelog and I can't see anything that 
should cause this.

-- 
Truth is stranger than fiction because fiction has to make sense.

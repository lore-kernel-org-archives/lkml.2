Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab2EVCy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:54:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57448 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2EVCy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:54:57 -0400
MIME-Version: 1.0
Date: Mon, 21 May 2012 21:54:56 -0500
Message-ID: <CAGFGw3m_aTYv7hGYVQAajoQJ5nD7jE8iO9VdjFtQZcA72kKPew@mail.gmail.com>
Subject: v3.4 will not compile
From: James Borum <james.borum@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't seem to get v3.4 to compile.  See below for the error.

v3.3.3 works fine, did a make oldconfig on that one with all defaults
on Slackware64 13.37

ARCH=x86_64

  CC      arch/x86/lib/usercopy.o
  CC      arch/x86/lib/usercopy_64.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
fs/built-in.o: In function `gfs2_lock':
file.c:(.text+0x3d7689): undefined reference to `dlm_posix_lock'
file.c:(.text+0x3d76c8): undefined reference to `dlm_posix_unlock'
file.c:(.text+0x3d76e8): undefined reference to `dlm_posix_get'
fs/built-in.o: In function `gdlm_cancel':
lock_dlm.c:(.text+0x3e9e75): undefined reference to `dlm_unlock'
fs/built-in.o: In function `gdlm_lock':
lock_dlm.c:(.text+0x3ea082): undefined reference to `dlm_lock'
fs/built-in.o: In function `gdlm_unmount':
lock_dlm.c:(.text+0x3ea60e): undefined reference to `dlm_release_lockspace'
fs/built-in.o: In function `control_unlock':
lock_dlm.c:(.text+0x3ea7dd): undefined reference to `dlm_unlock'
fs/built-in.o: In function `sync_lock':
lock_dlm.c:(.text+0x3ea920): undefined reference to `dlm_lock'
fs/built-in.o: In function `gdlm_put_lock':
lock_dlm.c:(.text+0x3eb1fc): undefined reference to `dlm_unlock'
fs/built-in.o: In function `gdlm_mount':
lock_dlm.c:(.text+0x3eb5ad): undefined reference to `dlm_new_lockspace'
lock_dlm.c:(.text+0x3eb869): undefined reference to `dlm_unlock'
lock_dlm.c:(.text+0x3eb8d1): undefined reference to `dlm_release_lockspace'
make: *** [.tmp_vmlinux1] Error 1

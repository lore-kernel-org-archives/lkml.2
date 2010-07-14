Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab0GNXdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:33:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65081 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0GNXdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wEFsqzhu0S6gQXRrupHxzC01x9grTa7YmVa5DTD+jHZbUcp11PHKMxo3GRTQ8817oe
         k3j/yz7o03PkpjQQ5ND+kWYl0YigwqaiHR7eLUl1X+OzWcOJ7csz2/TWDJqGy8be9A3f
         qpMGKEY7Z0cP0yIjZ+5zEjb4vSDVEJdjks/zg=
MIME-Version: 1.0
Date: Wed, 14 Jul 2010 17:33:38 -0600
Message-ID: <AANLkTim2dCrCisUmunVsUoP3uSvYDvRvNPUD0eNFxPwj@mail.gmail.com>
Subject: Linux 2.6.28.10 and Linux 2.6.29.6 XEN Guest Support Broken x86_64 in 
	BUILD
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[root@cloudstream linux-2.6.29.6]#
[root@cloudstream linux-2.6.29.6]#
[root@cloudstream linux-2.6.29.6]#
[root@cloudstream linux-2.6.29.6]# make bzImage modules modules_install install
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  AS      arch/x86/xen/xen-asm_64.o
arch/x86/xen/xen-asm_64.S: Assembler messages:
arch/x86/xen/xen-asm_64.S:48: Error: suffix or operands invalid for `mov'
arch/x86/xen/xen-asm_64.S:55: Error: suffix or operands invalid for `test'
arch/x86/xen/xen-asm_64.S:72: Error: suffix or operands invalid for `mov'
arch/x86/xen/xen-asm_64.S:90: Error: suffix or operands invalid for `test'
arch/x86/xen/xen-asm_64.S:110: Error: suffix or operands invalid for `setz'
arch/x86/xen/xen-asm_64.S:116: Error: suffix or operands invalid for `cmp'
make[1]: *** [arch/x86/xen/xen-asm_64.o] Error 1
make: *** [arch/x86/xen] Error 2
[root@cloudstream linux-2.6.29.6]#

 Jeff Merkey

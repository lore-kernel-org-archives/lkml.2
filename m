Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0KSQoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:44:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34834 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0KSQoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=FG8jcomXfZiqeyMHwfmpwi5s06SXlxjlP0/zmg+ZnsXOU4WIS8DFbIcUhJCPF6B1U3
         SnspwKL5CSydfkrTPGbD16Ld8RZNVypa6WRhoCRB21+H108lqPL+C5P/QCW6zs3upmTz
         zhoeyOlMKO4EPaTmZuzdXOOPt8a9tn0WzW4PQ=
MIME-Version: 1.0
Date: Fri, 19 Nov 2010 09:44:05 -0700
Message-ID: <AANLkTikndAO4Y0=5xwvBedgWzEUFM4UboaLZzSQwSYff@mail.gmail.com>
Subject: error with compiler.h when switching from 2.6.32 to 2.6.36
From: Derek Nielson <dereknielson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am switching from Kernel 2.6.32 to Kernel 2.6.36.  The kernel builds
fine but when I compile a module (that worked with the previously
kernel) against the new kernel I am getting an error that I don't
understand.

Here is the error:

In file included from include/linux/string.h:10,
                 from
/mnt/local/home/linux-omap-2.6/arch/arm/include/asm/uaccess.h:14,
                 from /home/my_module/my_module.c:24:
include/linux/compiler.h:62: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘struct’
make[2]: *** [/home/my_module/my_module.o] Error 1
make[1]: *** [_module_/home/my_module] Error 2
make[1]: Leaving directory `/mnt/local/home/linux-omap-2.6'
make: *** [release] Error 2

I found this thread http://lkml.org/lkml/2007/10/17/213 and tried
following their solution but it didn't fix the problem.

Does anyone know how to fix this error?

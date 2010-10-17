Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0JQAs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:48:59 -0400
Received: from mail.vyatta.com ([76.74.103.46]:43026 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab0JQAs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:48:58 -0400
Date: Sat, 16 Oct 2010 17:48:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-kernel@vger.kernel.org
Subject: Random compiler errors
Message-ID: <20101016174854.4b8eec07@s6510>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure why this is happening, but lately when building kernels
I am getting non-reproducible cases of gcc failure. There are no
messages in system log. Cosmic rays? Bad memory?

  CC      arch/x86/kernel/xsave.o
  CC      arch/x86/kernel/ptrace.o
arch/x86/kernel/ptrace.c:1416: internal compiler error: Bus error
Please submit a full bug report,
with preprocessed source if appropriate.
See <file:///usr/share/doc/gcc-4.4/README.Bugs> for instructions.
make[2]: *** [arch/x86/kernel/ptrace.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

$ make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      arch/x86/kernel/ptrace.o
  CC      arch/x86/kernel/tls.o
  CC      arch/x86/kernel/step.o
  CC      arch/x86/kernel/tboot.o

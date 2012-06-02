Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab2FBQPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 12:15:11 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:46388 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab2FBQPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 12:15:09 -0400
Date: Sat, 2 Jun 2012 18:15:02 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>
Subject: WARNING: arch/x86/built-in.o: Section mismatch in reference from
 the variable test_nmi_ipi_callback_na to function
 .ini.text:test_nmi_ipi_callback
Message-ID: <20120602161502.GW16584@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

x86 32-bit Build just got 2 WARNINGS when building kernel on Linus' tree.


 VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.10451 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference from the variable nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.10399 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.data+0x7cf0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.10451 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: vmlinux.o(.data+0x7d04): Section mismatch in reference from the variable nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.10399 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

  GEN     .version
  CHK     include/generated/compile.h




This is recent change.

gcc version 4.7.0 (Debian 4.7.0-11) 

Debian sid, i386.

-- 
Witold Baryluk

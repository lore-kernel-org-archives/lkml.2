Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2HCPAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:00:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2HCPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:00:10 -0400
Date: Fri, 3 Aug 2012 10:00:04 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc1:   apple-gmux  don't link, that mess the wole
 compilation because no vmlinuz produced
Message-ID: <20120803150004.GD8165@thinkpad-t410>
Mail-Followup-To: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
References: <web-777101016@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-777101016@zbackend1.aha.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 02:35:08AM -0400, werner wrote:
>  CC      init/version.o
>   LD      init/built-in.o
> drivers/built-in.o: In function `gmux_probe':
> apple-gmux.c:(.devinit.text+0x6daa8): undefined reference to
> `apple_bl_unregister'
> drivers/built-in.o: In function `gmux_remove':
> apple-gmux.c:(.devexit.text+0x8f80): undefined reference to
> `apple_bl_register'
> make: [vmlinux] Error 1 (ignored)
>   CC      arch/x86/boot/a20.o
>   AS      arch/x86/boot/bioscall.o
>   CC      arch/x86/boot/cmdline.o
>   AS      arch/x86/boot/copy.o
>   HOSTCC  arch/x86/boot/mkcpustr
>   CPUSTR  arch/x86/boot/cpustr.h
>   CC      arch/x86/boot/cpu.o
>   CC      arch/x86/boot/cpucheck.o
>   CC      arch/x86/boot/early_serial_console.o
>   CC      arch/x86/boot/edd.o
> make[1]: *** No rule to make target `vmlinux', needed by
> `arch/x86/boot/voffset.h'.

This is probably fixed by https://lkml.org/lkml/2012/8/2/286, but if
you'll send the config your using when you get this error I'll double
check.

Seth


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2HRNlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:41:42 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:51324 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2HRNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:41:40 -0400
Date: Sat, 18 Aug 2012 15:41:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: linux-sh@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: Re: Build regressions/improvements in v3.6-rc2
In-Reply-To: <alpine.DEB.2.00.1208181538001.21972@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1208181538320.22662@ayla.of.borg>
References: <alpine.DEB.2.00.1208181538001.21972@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.6-rc2 to v3.6-rc1[3], the summaries are:
>   - build errors: +4/-6

  + arch/sh/lib/mcount.S: Error: pcrel too far:  => 89

sh-allyesconfig

  + drivers/input/touchscreen/eeti_ts.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 243:2
  + drivers/input/touchscreen/eeti_ts.c: error: implicit declaration of function 'gpio_request_one' [-Werror=implicit-function-declaration]:  => 205:2

xtensa-allmodconfig

  + error: No rule to make target /scratch/kisskb/build/linus_m68k-allmodconfig_m68k/usr/include/linux/kvm_para.h:  => N/A

Known issue with kvm_para.h header export

> [1] http://kisskb.ellerman.id.au/kisskb/head/5338/ (all 116 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5315/ (all 116 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

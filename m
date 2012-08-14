Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2HNTIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:08:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39698 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2HNTIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:08:52 -0400
Message-ID: <502AA240.8050403@googlemail.com>
Date: Tue, 14 Aug 2012 21:08:48 +0200
From: Stefan Beller <stefanbeller@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: miss-leading help in configuration options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was configuring a kernel build and stumbled across some options, which
default to [n], but the help says "If unsure, say Y".
Also the other way round defaulting to [y],
but the help saying "If unsure, say N".

So now I am really unsure, what to pick.
Here is a list of options, which I found with a script to have such
unsure help:


./arch/blackfin/Kconfig.debug
config DEBUG_DOUBLEFAULT

./arch/sh/mm/Kconfig
config SCHED_MC

./arch/sparc/Kconfig
config SCHED_SMT
config SERIAL_CONSOLE

./arch/x86/Kconfig.cpu
config CPU_SUP_AMD
config CPU_SUP_CENTAUR
config CPU_SUP_CYRIX_32
config CPU_SUP_INTEL
config CPU_SUP_TRANSMETA_32
config CPU_SUP_UMC_32

./drivers/input/touchscreen/Kconfig
config TOUCHSCREEN_DA9034
config TOUCHSCREEN_USB_EASYTOUCH

./drivers/net/ethernet/stmicro/stmmac/Kconfig
config STMMAC_PLATFORM

./fs/ext3/Kconfig
config EXT3_FS_XATTR

./fs/ext4/Kconfig
config EXT4_FS_XATTR

./fs/notify/fanotify/Kconfig
config FANOTIFY

./lib/Kconfig.debug
config RCU_CPU_STALL_VERBOSE

./mm/Kconfig
config CLEANCACHE
config FRONTSWAP

./net/ipv4/Kconfig
config INET_UDP_DIAG

./net/Kconfig
config BRIDGE_NETFILTER

./net/unix/Kconfig
config UNIX_DIAG

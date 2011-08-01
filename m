Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1HAQQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:16:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42057 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1HAQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:16:19 -0400
Message-ID: <4E36D14F.5030100@lwfinger.net>
Date: Mon, 01 Aug 2011 11:16:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Suggestions for errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert,

In your "Build regressions/Improvements" postings, I keep seeing errors of the 
form below:

	v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:290: error: implicit 
declaration of function 'outl': 4 errors in 2 logs
	v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:295: error: implicit 
declaration of function 'outb': 4 errors in 2 logs
	v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:300: error: implicit 
declaration of function 'inb': 4 errors in 2 logs
	v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:305: error: implicit 
declaration of function 'inw': 4 errors in 2 logs

I do not know enough of the sh architecture to know how to fix this. Would 
including <asm-generic/io.h> work? Would there be any side effects for other 
architectures?

Thanks,

Larry

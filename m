Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2CJTYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 14:24:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2CJTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 14:24:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Ott <alan@signal11.us>
Subject: Re: [PATCH 1/2] ARM: at91: only RM9200 has ISA-style PIO
Date: Sat, 10 Mar 2012 19:24:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
References: <1331405049-3186-1-git-send-email-alan@signal11.us> <1331405075-3231-1-git-send-email-alan@signal11.us>
In-Reply-To: <1331405075-3231-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203101924.31710.arnd@arndb.de>
X-Provags-ID: V02:K0:CdsjRy2OzZRaFIws2gA+2dP08O+yi6x49QalTqlS5Ij
 U1Jr6k9nKSucsorW/roY3aTQ014OaGmNEzmhjweClV5T+phQry
 W8ql2/yS/MwXQA5N0JGnT4RjBpX3e9iyo4s8ltLCblepuZEOFa
 BLvVU+X9zk4r7nYv7tgns26P9+GWKKReR326MzBjmJKA9JH0Zy
 xzU5W45e4mRVmJRfLefExptBMBYwhxxVpB1W/wyTNCKbsR3TkS
 Uz+rtTsHPahrvYQq5Bpxn6+VjXKlf6qI01TPdFabmEV68XH9Pf
 8FLGlOfaOOrlNxrTUP8rFdQHoKAy+hoJ6S7bvG5B84Iw0T58l3
 zJMM318P2sx76ilfa2dE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2012, Alan Ott wrote:
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Most at91 systems have no support for PCMCIA or other
> PC-style buses, so we can select NO_IOPORT in order to
> disable compilationf or all drivers that need these.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alan Ott <alan@signal11.us>

Hi Alan,

You forgot to Cc the at91 maintainers on this patch (and on patch 0).
Also, this patch relies on the another series I did to redefine
the meaning of CONFIG_NO_IOPORT while renaming the existing one to
CONFIG_NO_IOPORT_MAP. This patch will have to wait for the other
series.

	Arnd

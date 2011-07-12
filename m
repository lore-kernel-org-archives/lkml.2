Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1GLSoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:44:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1GLSoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:44:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 0/11 v3] Generic Watchdog Timer Driver
Date: Tue, 12 Jul 2011 20:43:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
References: <20110711135056.GT29245@infomag.iguana.be>
In-Reply-To: <20110711135056.GT29245@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107122043.16528.arnd@arndb.de>
X-Provags-ID: V02:K0:zbx7tvB1m2XxUaCwc0ww9FoZruqArtOEYlMUudAyeus
 A7CfbgKGA1KHkx1HJccbpaZrTLPjSnCeMCz6ksGOfT3vI9EQre
 f7dfud9LexJzRwlPvr3/To3KtZL31zv2qiYdR4W+eWlfFZhXBP
 eZZYF8RMCVvZxdeAdE+m5OieUweQFT6OmyFZx+vJLr4I9Dfj7z
 PpK4TyIuIKocEPR7tVZWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 July 2011 15:50:56 Wim Van Sebroeck wrote:
> To reduce copying the same code over and over in each watchdog device driver,
> Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.
> I incorporated the changes/feedback that I received from the second post.
> 
> This framework/API consists of the following patches:
> part  1: Introduction of the WatchDog Timer Driver Core
> part  2: Add the basic ioctl functionality
> part  3: Add the WDIOC_KEEPALIVE ioctl
> part  4: Add the WDIOC_SETOPTIONS ioctl
> part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> part  6: Add the Magic Close feature
> part  7: Add the nowayout feature
> part  8: Add support for a miscdev parent device
> part  9: Add support for extra ioctl calls
> part 10: Add the minimum and maximum timeout parameters.
> part 11: Remove llseek

Acked-by: Arnd Bergmann <arnd@arndb.de>, the whole series.

As far as I can tell, all the issues I've raised the last time have been
resolved, in a lot of cases by convincing me that your solution was
ok to start with ;-)

	Arnd

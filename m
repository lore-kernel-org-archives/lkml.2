Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1FRTFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:05:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51419 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1FRTFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:05:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 5/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 21:04:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172357.GF3441@infomag.iguana.be>
In-Reply-To: <20110618172357.GF3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182104.41366.arnd@arndb.de>
X-Provags-ID: V02:K0:9TVK0r9SCUcqS8dcHLj3+4GlVHorqZs5zjPCuv3azmm
 yVflwsSntTnVvuehYKVqx3BSgbyozi4LWski2XH9jojX6bQ0Rm
 +t8oYXzJYdd7PPL9uMPpzfDRiJjw5TMonS/VFv4ggLD/qarYVs
 1di7Ycph5RQA6fEzcZLvHZYBUx9MDxpYcPMgss8HsFg0x97gDB
 bxNM0IUEOHDWao8d7ZyWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:23:57 Wim Van Sebroeck wrote:
> watchdog: WatchDog Timer Driver Core - Part 5
> 
> This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> functionality to the WatchDog Timer Driver Core framework.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Acked-by: Arnd Bergmann <arnd@arndb.de>

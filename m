Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1FRTDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:03:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1FRTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:03:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 4/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 21:03:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172301.GE3441@infomag.iguana.be>
In-Reply-To: <20110618172301.GE3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182103.18614.arnd@arndb.de>
X-Provags-ID: V02:K0:Zyvwj0yg7vA97UHyRMtAx+c4OqWksUD8a9L/98LgyBL
 q89y3lKOTI9+/iOh03IE6Xl/mzOoErE7IaToUranzzqVlEH6rm
 AcwdoH89ntyceGg/xrf+X7vr5d1ATlsbTMSJF7U3qZTL5L1+Ax
 uok1zLXnLW7IJREJONlFWG8Z+bqScqto0SI2oS09ulXw435Pm+
 c/c0OKG9ZhUxIV38O9cbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:23:01 Wim Van Sebroeck wrote:
> 
> watchdog: WatchDog Timer Driver Core - Part 4
> 
> This part add's the WDIOC_SETOPTIONS ioctl functionality
> to the WatchDog Timer Driver Core framework.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>

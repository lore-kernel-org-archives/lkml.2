Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1FRTKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:10:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1FRTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:10:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 10/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 21:10:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172832.GK3441@infomag.iguana.be>
In-Reply-To: <20110618172832.GK3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182110.23801.arnd@arndb.de>
X-Provags-ID: V02:K0:dm+3oyi+HyaI/Wci/qWFEh68oyCXZscDXUCNsF4jCOy
 n2aFgxbXMmkOcKnKsIyGVEjZPm2o+EVJOFqJlXfQ6EsaaVvcoW
 oTq/kdCVC7MIx3mXftC82z5cHhDfU2r5wdR/W0QDFGnL+oO+/8
 TcpAB6tE0LI02ImjCaIxrXoK5T/JSx/QndlqLvBHdz1RYcDtC5
 OZAFXsVfc1jkWCQwwJD1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:28:32 Wim Van Sebroeck wrote:
> 
> watchdog: WatchDog Timer Driver Core - Part 10
> 
> Add min_timeout (minimum timeout) and max_timeout
> values so that the framework can check if the new
> timeout value is between the minimum and maximum
> timeout values. If both values are 0, then the
> framework will leave the check for the watchdog
> device driver itself.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Acked-by: Arnd Bergmann <arnd@arndb.de>

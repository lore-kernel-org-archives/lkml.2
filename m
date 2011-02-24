Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1BXIVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:21:07 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:51366 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab1BXIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:21:05 -0500
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Feb 2011 03:21:05 EST
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [RFC] [PATCH 5/10] Generic Watchdog Timer Driver
Date: Thu, 24 Feb 2011 09:21:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110223204330.GA7417@infomag.iguana.be>
In-Reply-To: <20110223204330.GA7417@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102240921.02967.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 February 2011, 21:43:30 Wim Van Sebroeck wrote:
> commit 1959ea403c69af855f5cd13e5c9b33123d2137b2
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Fri Jun 18 09:45:49 2010 +0000
> 
>     watchdog: WatchDog Timer Driver Core - Part 5
> 
>     This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
>     functionality to the WatchDog Timer Driver Core framework.
> 
>     Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> [snip]

Any specific reason you can only specify seconds as timeout? There is no way 
to set a timeout of e.g. 500ms or 1500ms.
You can change this by using using a struct timeval for setting a timeout. 
What do you think?

Alexander

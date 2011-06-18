Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1FRTCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:02:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1FRTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:01:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 3/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 21:01:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172136.GD3441@infomag.iguana.be>
In-Reply-To: <20110618172136.GD3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182101.40334.arnd@arndb.de>
X-Provags-ID: V02:K0:YoaGb99yRmAbZqT2sOmEAd5rHzk0m5iBmZ7mlpoLJOW
 fI4FmspvEnQCswDgzENVB5wxNtnDsgh5JHE3UtriQg1jUKd98A
 nVkXeTyjLfwwgrrQv2ITl/JY4CzZIRtQ2q/Ae3N0qJa9m69+VP
 gp0cZmRTgvkwBlHx+Oo2sREHkINvv1lNpjWlALYVkRKZTX/ElQ
 Q3BAhC6vyMkBwrNIQjOPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:21:36 Wim Van Sebroeck wrote:
> watchdog: WatchDog Timer Driver Core - Part 3
> 
> This part add's the WDIOC_KEEPALIVE ioctl functionality to the
> WatchDog Timer Driver Core framework. Please note that the
> WDIOF_KEEPALIVEPING bit has to be set in the watchdog_info
> options field.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Acked-by: Arnd Bergmann <arnd@arndb.de>

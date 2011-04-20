Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1DTGkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:40:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab1DTGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:40:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 0/4] Posix Alarm Timers
Date: Wed, 20 Apr 2011 08:40:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
References: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104200840.33671.arnd@arndb.de>
X-Provags-ID: V02:K0:fvFJuO695eKgMFLK5OFgJSAzsnbE/BG589aN7txa8sz
 G2MIjR2/XNnLKCmYkWwiwhtgpI+0pX82OsAMMwNay9IV60rN7Q
 4omdmc3lwQObqzCZSkEmet6uim7QD0HeMfl3Ljdq0XItq3HiTF
 qqKKga0vSSKmVcImKdnO5TqCzqnivsVAVY+z9hu2CIOEDUzIEg
 dQnjcClC+qEVn3EegdLtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 April 2011 01:58:26 John Stultz wrote:
> 
> Just wanted to send out my current Posix Alarm Timers queue for 
> comment and review in the hopes of getting it into shape for
> 2.6.40.
> 
> Some background on the patches can be found here:
>         https://lwn.net/Articles/429925/
> 
> New in this series:
> * Added timekeeping_inject_sleeptime, which corrects CLOCK_BOOTTIME
>   for arches that don't support read_persistent_clock().
> * I've added a CAP_WAKE_ALARM capability to limit random applications
>   from setting alarms in the last patch. This probably needs some
>   careful review as it allows clock_nanosleep and timer_create to
>   return -EPERM, which is new behavior.
> 
I haven't looked at these patches much before, so I've done a brief
review now. They look very nice, and I can't find anything to complain
about.

Acked-by: Arnd Bergmann <arnd@arndb.de>

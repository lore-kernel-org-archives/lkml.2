Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0JQE5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 00:57:44 -0400
Received: from mail.wdtv.com ([66.118.69.84]:49192 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0JQE5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 00:57:43 -0400
From: gene heskett <gheskett@wdtv.com>
To: maciej.rutecki@gmail.com
Subject: Re: [2.6.36-rc8] ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
Date: Sun, 17 Oct 2010 00:50:57 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.7; KDE/4.5.2; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
References: <201010161942.03081.maciej.rutecki@gmail.com>
In-Reply-To: <201010161942.03081.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010170050.57530.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 16, 2010, Maciej Rutecki wrote:
>Dear all
>
>During compiling 2.6.36-rc8:
>CC [M]  net/wireless/wext-compat.o
>  CC [M]  net/wireless/wext-sme.o
>  CC [M]  net/wireless/lib80211.o
>  LD [M]  net/wireless/cfg80211.o
>  Building modules, stage 2.
>  MODPOST 344 modules
>ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
>ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
>make[2]: *** [__modpost] Błąd 1
>make[1]: *** [modules] Błąd 2
>make[1]: Opuszczenie katalogu `/usr/src/linux-2.6.36-rc8'
>make: *** [debian/stamp/build/kernel] Błąd 2
>
>Three different machines (laptop, PC and virtualbox), the same problem.
>
>Regards

That makes at least 2 of us with this problem, but I don't believe I'm 
sharp enough in my dotage to fix it.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Computer programmers do it byte by byte.

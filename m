Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab0JQAuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:50:00 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57765 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab0JQAt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:49:57 -0400
To: maciej.rutecki@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc8] ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201010161942.03081.maciej.rutecki@gmail.com>
In-Reply-To: <201010161942.03081.maciej.rutecki@gmail.com>
Message-Id: <201010170949.EHE37827.MJFLOtSQVFOHFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 17 Oct 2010 09:49:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> During compiling 2.6.36-rc8:
> CC [M]  net/wireless/wext-compat.o
>   CC [M]  net/wireless/wext-sme.o
>   CC [M]  net/wireless/lib80211.o
>   LD [M]  net/wireless/cfg80211.o
>   Building modules, stage 2.
>   MODPOST 344 modules
> ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
> ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
> make[2]: *** [__modpost] B??d 1
> make[1]: *** [modules] B??d 2
> make[1]: Opuszczenie katalogu `/usr/src/linux-2.6.36-rc8'
> make: *** [debian/stamp/build/kernel] B??d 2

Fixed in 2.6.36-rc8-git1 .
You can apply http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8fd01d6cfbf75465d84a4e533ed70c5f57b3ff51#patch1 .

Regards.

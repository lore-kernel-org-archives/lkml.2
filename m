Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1EZMuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:50:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1EZMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:50:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 0/6] unicore32 subsystem: 6 patches for 2.6.39
Date: Thu, 26 May 2011 14:50:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, greg@kroah.com
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261450.01277.arnd@arndb.de>
X-Provags-ID: V02:K0:KKo7+a4JkWb65ScHWdFaq9VxREaltxCc4mUUGhJ8ZfV
 4os2YGKdFmfjelPxoF3edXSuHj0XreyzGFXIsPhCHMEmVsTJ0R
 nhDxS+n/lANbwXol/24Ou9YgXivGv469w2Q+NaQ/cPU5bKB7Dk
 HISzYkKxNr7XD1aZsQLnZuW8JFk6CVpEG78OuMrVCEtZCQ5Krq
 9LFz4n7bFEx2nza5qZkbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, GuanXuetao wrote:
> Two patches for PKUnity v3 SoC drivers:
>         add mac driver, and move rtc driver to appropriate place
> Two patches for new 2.6.39 updates:
>         using generic-y and modify PERCPU macro
> Other two patches are small fixes.
> 
> ---
> Guan Xuetao (6):
>   unicore32: move rtc-puv3.c to drivers/rtc directory
>   unicore32: add pkunity-v3 mac/net driver (umal)
>   unicore32: change zImage physical address, though it's PIC codes
>   unicore32: add KBUILD_DEFCONFIG with unicore32_defconfig (old
>     debug_defconfig)
>   unicore32: change PERCPU to PERCPU_SECTION
>   unicore32: using generic-y format for one line asm-generic files
> 

The patches look basically ok, but two points to remember:

* The merge window is not the time to post patches for review, if you
  want to collect Acked-by's from other people, do that in the
  time between the merge windows, then put the patches in your git
  tree with the Acked-by for linux-next. During the merge window, just
  send stuff that was already in your tree to Linus.

  Bug fixes should get sent to Linus at any time, but I think you already
  did that, all of these were either new features or cleanups.

* Add a small text explaining why you do something to each patch. The
  one-line summary that you always have is too short for this and only
  serves to list what you change, not why.

	Arnd

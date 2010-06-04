Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0FDTdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:33:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab0FDTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:33:22 -0400
Date: Fri, 4 Jun 2010 12:32:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Rename ramzswap files to zram
Message-Id: <20100604123246.3e11022e.akpm@linux-foundation.org>
In-Reply-To: <1275379286-10453-3-git-send-email-ngupta@vflare.org>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-3-git-send-email-ngupta@vflare.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jun 2010 13:31:24 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> Related changes:
>  - Modify revelant Kconfig and Makefile accordingly.
>  - Change include filenames in code.
>  - Remove dependency on CONFIG_SWAP in Kconfig as zram usage
> is no longer limited to swap disks.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/Kconfig                            |    2 +-
>  drivers/staging/Makefile                           |    2 +-
>  drivers/staging/ramzswap/Kconfig                   |   21 ---------------
>  drivers/staging/ramzswap/Makefile                  |    3 --
>  drivers/staging/zram/Kconfig                       |   28 ++++++++++++++++++++
>  drivers/staging/zram/Makefile                      |    3 ++
>  drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
>  drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
>  drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
>  .../{ramzswap/ramzswap.txt => zram/zram.txt}       |    0
>  .../{ramzswap/ramzswap_drv.c => zram/zram_drv.c}   |    2 +-
>  .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |    2 +-
>  .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |    0
>  13 files changed, 35 insertions(+), 28 deletions(-)
>  delete mode 100644 drivers/staging/ramzswap/Kconfig
>  delete mode 100644 drivers/staging/ramzswap/Makefile
>  create mode 100644 drivers/staging/zram/Kconfig
>  create mode 100644 drivers/staging/zram/Makefile
>  rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
>  rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
>  rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
>  rename drivers/staging/{ramzswap/ramzswap.txt => zram/zram.txt} (100%)
>  rename drivers/staging/{ramzswap/ramzswap_drv.c => zram/zram_drv.c} (99%)
>  rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (99%)
>  rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (100%)

This is a git-specific thing and doesn't do anything useful for people
who use plain-old-patch(1) (eg: Greg and me).

Obviously we can manually type in the commands and put the massive
file-moving diff together, but it's a bit of a pain.

Maybe Greg has some magic automated way of turning these into regular
patches, but I don't.


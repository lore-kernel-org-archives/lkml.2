Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0HIJX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:23:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab0HIJX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:23:27 -0400
Date: Mon, 9 Aug 2010 11:23:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Weil <weil@mail.berlios.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix spelling fuction -> function in comments
In-Reply-To: <1281121875-3577-1-git-send-email-weil@mail.berlios.de>
Message-ID: <alpine.LNX.2.00.1008091120250.29919@pobox.suse.cz>
References: <1281121875-3577-1-git-send-email-weil@mail.berlios.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010, Stefan Weil wrote:

> To avoid more patches, I also fixed other spelling
> and grammar bugs when they were in the same or
> following line:
> 
> successfull -> successful
> parse -> parses
> controler -> controller
> controlers -> controllers
> 
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  arch/blackfin/mach-bf527/boards/ezkit.c            |    2 +-
>  arch/blackfin/mach-bf537/boards/stamp.c            |    2 +-
>  arch/xtensa/include/asm/uaccess.h                  |    2 +-
>  block/blk-core.c                                   |    2 +-
>  drivers/base/core.c                                |    2 +-
>  drivers/media/video/zoran/videocodec.h             |    2 +-
>  drivers/net/depca.c                                |    2 +-
>  drivers/net/igb/igb_main.c                         |    2 +-
>  drivers/net/skfp/hwt.c                             |    2 +-
>  drivers/net/skfp/skfddi.c                          |    2 +-
>  drivers/s390/block/dasd_3990_erp.c                 |    2 +-
>  drivers/s390/char/tape_3590.c                      |    6 +++---
>  drivers/scsi/lpfc/lpfc_hbadisc.c                   |    2 +-
>  .../rtl8187se/ieee80211/ieee80211_softmac.c        |    4 ++--
>  .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    2 +-
>  .../rtl8192su/ieee80211/ieee80211_softmac.c        |    2 +-
>  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
>  drivers/usb/host/imx21-hcd.c                       |    4 ++--
>  net/mac80211/mesh.h                                |    2 +-
>  19 files changed, 23 insertions(+), 23 deletions(-)

Hi Stefan,

thanks for the patch. I only have one request -- could you please split 
up the staging patches, and send them separately to the staging tree 
maintainer?

I have now applied all the changes except the ones touching 
drivers/staging to my tree, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

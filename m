Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab0I0Sic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:38:32 -0400
Received: from xenotime.net ([72.52.115.56]:45008 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757166Ab0I0Sib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:38:31 -0400
Date: Mon, 27 Sep 2010 11:38:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        forest@alittletooquiet.net, yunpeng.gao@intel.com, vmehta@atheros.com
Subject: Re: linux-next: Tree for September 27 (staging: ath6kl, spectra, &
 vt6655)
Message-Id: <20100927113829.2928636a.rdunlap@xenotime.net>
In-Reply-To: <20100927162143.3a9c1efe.sfr@canb.auug.org.au>
References: <20100927162143.3a9c1efe.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 16:21:43 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100924:


drivers/staging/ath6kl/os/linux/ar6000_drv.c:1370:1: warning: "CONFIG_AR600x_BT_RESET_PIN" redefined
./include/generated/autoconf.h:419:1: warning: this is the location of the previous definition
drivers/staging/ath6kl/os/linux/ioctl.c:4673: warning: the frame size of 2052 bytes is larger than 1024 bytes
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error: 'struct mmc_host' has no member named 'max_hw_segs'
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error: 'struct mmc_host' has no member named 'max_hw_segs'

drivers/staging/spectra/ffsport.c:659: error: implicit declaration of function 'blk_queue_ordered'
drivers/staging/spectra/ffsport.c:659: error: 'QUEUE_ORDERED_DRAIN_FLUSH' undeclared (first use in this function)

drivers/staging/vt6655/device_main.c:3579: warning: the frame size of 1868 bytes is larger than 1024 bytes


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134Ab0I0T2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:28:43 -0400
Received: from mail.atheros.com ([12.19.149.2]:36661 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703Ab0I0T2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:28:42 -0400
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "forest@alittletooquiet.net" <forest@alittletooquiet.net>,
        "yunpeng.gao@intel.com" <yunpeng.gao@intel.com>
Date: Mon, 27 Sep 2010 12:28:40 -0700
Subject: RE: linux-next: Tree for September 27 (staging: ath6kl, spectra, &
 vt6655)
Thread-Topic: linux-next: Tree for September 27 (staging: ath6kl, spectra, &
 vt6655)
Thread-Index: Actecy+qI7WntGk5R++QRYCfdjQxAwABhiQQ
Message-ID: <35B17FE5076C7040809188FBE7913F983F23AFDDA6@SC1EXMB-MBCL.global.atheros.com>
References: <20100927162143.3a9c1efe.sfr@canb.auug.org.au>
 <20100927113829.2928636a.rdunlap@xenotime.net>
In-Reply-To: <20100927113829.2928636a.rdunlap@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all,
> 
> Changes since 20100924:


drivers/staging/ath6kl/os/linux/ar6000_drv.c:1370:1: warning: "CONFIG_AR600x_BT_RESET_PIN" redefined
./include/generated/autoconf.h:419:1: warning: this is the location of the previous definition
drivers/staging/ath6kl/os/linux/ioctl.c:4673: warning: the frame size of 2052 bytes is larger than 1024 bytes
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error: 'struct mmc_host' has no member named 'max_hw_segs'
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error: 'struct mmc_host' has no member named 'max_hw_segs'

The problem is because the mmc stack is out of sync in Greg's staging tree and Stephen's linux-next tree. Greg asked me to generate a patch which I did and emailed to Greg. 

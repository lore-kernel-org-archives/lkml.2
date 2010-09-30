Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab0I3Q7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 12:59:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51815 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0I3Q7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 12:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b2XZk+vetLBQcB4vnbm6mt7q5cWDRv43xWCCMhMf4wDlPt0uBaRMxDfsWGt4Owr6FN
         X9cGDtepEvokgCbH9PXRNO72lJYEUmdL9tVc9AcSEh2CigVCRdT7aXHp9q7NMwnzOfiE
         0dKELagrCzNS5vAdj7dqAy/N68zkSacoHmlNk=
MIME-Version: 1.0
In-Reply-To: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
Date: Thu, 30 Sep 2010 18:59:30 +0200
Message-ID: <AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: Na Pohybel <napohybelskurwysynom2010@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/9/29  <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to

Could you add this tree to the next mmotm?
git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodi

It removes some duplicate includes

 arch/arm/mach-davinci/board-da850-evm.c        |    1 -
 arch/arm/mach-shmobile/board-ap4evb.c          |    1 -
 arch/arm/mach-tegra/timer.c                    |    1 -
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    1 -
 arch/tile/kernel/setup.c                       |    2 --
 arch/x86/mm/init_64.c                          |    1 -
 arch/x86/xen/enlighten.c                       |    1 -
 drivers/ide/ide-tape.c                         |    1 -
 drivers/media/IR/lirc_dev.c                    |    1 -
 drivers/net/pxa168_eth.c                       |    2 --
 drivers/net/wireless/libertas/cfg.c            |    1 -
 drivers/platform/x86/intel_pmic_gpio.c         |    1 -
 drivers/staging/lirc/lirc_parallel.c           |    1 -
 drivers/staging/spectra/lld_mtd.c              |    3 ---
 drivers/staging/tidspbridge/gen/gb.c           |    1 -
 drivers/staging/tidspbridge/gen/gs.c           |    1 -
 drivers/video/omap/lcd_omap3beagle.c           |    1 -
 include/linux/virtio_9p.h                      |    1 -
 kernel/trace/trace_kprobe.c                    |    1 -
 net/caif/caif_socket.c                         |    1 -
 net/netfilter/xt_ipvs.c                        |    1 -
 sound/soc/nuc900/nuc900-ac97.c                 |    1 -
 22 files changed, 0 insertions(+), 26 deletions(-)


-- 
Slawa!
N.P.S.

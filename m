Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2FSGaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:30:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48719 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2FSGaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:30:20 -0400
MIME-Version: 1.0
X-Originating-IP: [212.143.84.146]
In-Reply-To: <CAAAP30G1qzDn+NKT1is+GJ9K2DS3Sm3QY+=n7s-P-Rop2b7FPQ@mail.gmail.com>
References: <1340037743-12924-1-git-send-email-stigge@antcom.de>
 <1340037743-12924-2-git-send-email-stigge@antcom.de> <CAAAP30G1qzDn+NKT1is+GJ9K2DS3Sm3QY+=n7s-P-Rop2b7FPQ@mail.gmail.com>
From: Leon Romanovsky <leon@leon.nu>
Date: Tue, 19 Jun 2012 09:29:58 +0300
Message-ID: <CALq1K=LXVqfiyrLjn+_p+NTU3X5RjyQzvKdVRf09zXk-RqbkrQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] sound: tegra_alc5632: Adjust to of_get_named_gpio() change
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, swarren@wwwdotorg.org, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 8:28 PM, Alexandre Pereira da Silva
<aletes.xgr@gmail.com> wrote:
> On Mon, Jun 18, 2012 at 1:42 PM, Roland Stigge <stigge@antcom.de> wrote:
>> of_get_named_gpio() was changed to return -EPROBE_DEFER in case of
>> gpios not probed yet. This patch adjusts tegra_alc5632 to this.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Hi Alexandre,
Sorry to be rude, but can you explain me why did you "Acked-by" on this patch ?
I don't see your name in git log for tegra_alc5632.c file:
http://git.kernel.org/?p=linux/kernel/git/broonie/sound.git;a=history;f=sound/soc/tegra/tegra_alc5632.c;h=d684df294c0c5c80458b6de591c16965027db14b;hb=refs/heads/for-next

Thanks.

-- 
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu

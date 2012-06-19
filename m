Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2FSLD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:03:26 -0400
Received: from antcom.de ([188.40.178.216]:57402 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2FSLDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:03:24 -0400
Message-ID: <4FE05C79.1040602@antcom.de>
Date: Tue, 19 Jun 2012 13:03:21 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Leon Romanovsky <leon@leon.nu>, swarren@wwwdotorg.org, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] sound: tegra_alc5632: Adjust to of_get_named_gpio()
 change
References: <1340037743-12924-1-git-send-email-stigge@antcom.de> <1340037743-12924-2-git-send-email-stigge@antcom.de> <CAAAP30G1qzDn+NKT1is+GJ9K2DS3Sm3QY+=n7s-P-Rop2b7FPQ@mail.gmail.com> <CALq1K=LXVqfiyrLjn+_p+NTU3X5RjyQzvKdVRf09zXk-RqbkrQ@mail.gmail.com> <CAAAP30FoHAbA1HcUCGQxorFymVDed19N1PPe-ZH0x0s3M+W8bg@mail.gmail.com>
In-Reply-To: <CAAAP30FoHAbA1HcUCGQxorFymVDed19N1PPe-ZH0x0s3M+W8bg@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 12:03 PM, Alexandre Pereira da Silva wrote:
> On Tue, Jun 19, 2012 at 3:29 AM, Leon Romanovsky <leon@leon.nu> wrote:
>> Hi Alexandre,
>> Sorry to be rude, but can you explain me why did you "Acked-by" on this patch ?
>> I don't see your name in git log for tegra_alc5632.c file:
>> http://git.kernel.org/?p=linux/kernel/git/broonie/sound.git;a=history;f=sound/soc/tegra/tegra_alc5632.c;h=d684df294c0c5c80458b6de591c16965027db14b;hb=refs/heads/for-next
> 
> I'm tracking Roland's work on Probe defer.

Yes, that's valuable. Thanks!

Roland

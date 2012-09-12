Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864Ab2ILRaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:30:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab2ILR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:29:58 -0400
Message-ID: <5050C692.1070503@wwwdotorg.org>
Date: Wed, 12 Sep 2012 11:29:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Chris Ball <cjb@laptop.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 09/16] ARM: tegra: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-9-git-send-email-arnd@arndb.de> <504F5A51.9000506@wwwdotorg.org> <201209121621.16019.arnd@arndb.de>
In-Reply-To: <201209121621.16019.arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:21 AM, Arnd Bergmann wrote:
> On Tuesday 11 September 2012, Stephen Warren wrote:
> 
>>>  .../mach/sdhci.h => include/linux/platform_data/mmc-sdhci-tegra.h  |    0
>>
>> I have a not-yet-applied (but ack'd by Chris Ball) patch to move this to
>> include/linux/mmc/tegra_sdhci.h. I believe all the dependencies are
>> staged in the Tegra tree now, so I can apply it if you want. I'm fine
>> with you apply this patch though; just let me know. If you want to take
>> your patch, then this part:
>>
>> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> I've redone my patch now, the version below is what I have now.

OK, that looks fine.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2KSR3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:29:30 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48422 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2KSR33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:29:29 -0500
Message-ID: <50AA6C76.3000606@atmel.com>
Date: Mon, 19 Nov 2012 18:29:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
Subject: Re: [GIT PULL] at91: fixes for 3.7-rc7
References: <50AA5ED5.8090901@atmel.com> <CAOesGMjAYtEkmEYnzCQ4G821BWG9D6LHvgt5aOMJgus_hzFkRA@mail.gmail.com>
In-Reply-To: <CAOesGMjAYtEkmEYnzCQ4G821BWG9D6LHvgt5aOMJgus_hzFkRA@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 05:52 PM, Olof Johansson :
> Hi Nicolas,
> 
> On Mon, Nov 19, 2012 at 8:31 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>> Arnd, Olof,
>>
>> Here is another "fixes" pull request for AT91. It enables the sd/mmc driver
>> for Device Tree enabled platforms. Those patches where part of a series that
>> was split in two for reaching upstream: the MMC part is already in Linus' tree
>> and this is the arm-soc part.
>> I have placed these patches on top of the fixes that you already have for AT91.
> 
> What regressions do these fixes resolve?
> 
> It looks more like they are DT-enablement patches to me, and thus 3.8
> material, not 3.7. I'll be happy to queue them up in next/dt though.

Hi Olof,

You are right, it does not strictly fixes a regression and we were late
for including these patches which are around since end of July...
I still sent this pull-request to enable more people to use device tree
on AT91 for the upcoming release.

If you do not take it for 3.7, maybe we will have to queue these patches
on top of our AT91 pinctrl work (on Linus Walleij side), so, you do need
to queue this one for the moment...

Best regards,
-- 
Nicolas Ferre

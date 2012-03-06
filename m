Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2CFRBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:01:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41459 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2CFRBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:01:16 -0500
Message-ID: <4F5642D7.4090800@wwwdotorg.org>
Date: Tue, 06 Mar 2012 10:01:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH V2 3/3] gpio: tegra: Hide tegra_gpio_enable/disable()
References: <1330993336-9538-1-git-send-email-swarren@nvidia.com>	<1330993336-9538-3-git-send-email-swarren@nvidia.com> <CACRpkdaZ8EBBwGis4Odh1EZS=waB0nCSZ-mtUHx48ywE81T5Ng@mail.gmail.com>
In-Reply-To: <CACRpkdaZ8EBBwGis4Odh1EZS=waB0nCSZ-mtUHx48ywE81T5Ng@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 03:08 AM, Linus Walleij wrote:
> On Tue, Mar 6, 2012 at 1:22 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
>> Recent pinctrl discussions concluded that gpiolib APIs should in fact do
>> whatever is required to mux a GPIO onto pins, by calling pinctrl APIs if
>> required. This change implements this for the Tegra GPIO driver, and removes
>> calls to the Tegra-specific APIs from drivers and board files.
...
>> This patch should probably be taken
>> through the Tegra tree. Once patch 2 is in pinctrl, and considered stable,
>> I can just use that as a dependency for the branch containing this Tegra
>> patch. I assume that this series will go into 3.5 not 3.4, but I'm willing
>> to be surprised:-)
> 
> Should be possible if my pinctrl-tegra-for-next-diet branch is considered
> stable and could be pulled into the Tegra tree for further augmenting
> by this and other patches!
> 
> But I guess you'd need to merge some stable development base
> for the rest of the pinctrl stuff as well, shall I freeze the for-next
> branch with tegra diet stuff merged on top now? I can promise
> to just add new patches on top of that if it helps you.
> 
> Is Olof the one to ask?

For 3.4 yes Olof, but since this is probably going into 3.5, it's me!

At this point, I expect picking up a stable commit from pinctrl's
for-next branch would be the easiest for 3.5. Probably the same is true
for 3.4 too, since "everything" is in pinctrl's for-next now.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1HOFun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:50:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36254 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1HOFul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQ0ZWRX_POwMZY9m9ath=oC0OS538+wRcfj-vay5VSkSRkzEg@mail.gmail.com>
References: <1313375298-18546-1-git-send-email-shawn.guo@linaro.org>
	<m2mxfbmirn.fsf@bob.laptop.org>
	<CAAQ0ZWRX_POwMZY9m9ath=oC0OS538+wRcfj-vay5VSkSRkzEg@mail.gmail.com>
Date: Mon, 15 Aug 2011 13:50:40 +0800
Message-ID: <CAAQ0ZWSaqn7MdZ2EjxMwYgUcrECkO_Sa=jhKvAQDvfHeVy0Atg@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: add missing inclusion of linux/module.h
From: Shawn Guo <shawn.guo@linaro.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2011 13:35, Shawn Guo <shawn.guo@linaro.org> wrote:
> Hi Chris,
>
> On 15 August 2011 11:54, Chris Ball <cjb@laptop.org> wrote:
>> Hi Shawn,
>>
>> On Sun, Aug 14 2011, Shawn Guo wrote:
>>> There are following warning and error when compiling the driver.
>>> The patch adds the missing inclusion of linux/module.h to fix them.
>>>
>>> drivers/mmc/host/sdhci-esdhc-imx.c:87:1: warning: data definition has
>>> no type or storage class
>>
>> Pushed to mmc-next for 3.1.  I don't see these on my imx build with
>> CONFIG_MMC_SDHCI_ESDHC_IMX=m, so it'd be useful to see your .config
>> so that I'm able to reproduce in future.
>>
> I guess it's not about .config but sources.  I spot this on
> linux-next-20110812.  Are you trying the same tree?  I will test
> v3.1-rc2 tag when I can actually fetch it.  (Linus released it, but it
> has not been available with 'git fetch' yet.)
>
I just fetched v3.1-rc2 and did the build test.  The problem does not present.

-- 
Regards,
Shawn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2IMEgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:36:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55547 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2IMEgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:36:45 -0400
Message-ID: <505162DC.3060007@wwwdotorg.org>
Date: Wed, 12 Sep 2012 22:36:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] USB: phy: re-organize tegra phy driver
References: <1347447481-25574-1-git-send-email-vbyravarasu@nvidia.com> <5050D622.7080704@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6DDEFB8D80@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB8D80@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 09:49 PM, Venu Byravarasu wrote:
> Stephen Warren wrote at Thursday, September 13, 2012 12:06 AM:
>> On 09/12/2012 04:58 AM, Venu Byravarasu wrote:
>>> Nvidia produces several Tegra SOCs viz Tegra2, Tegra3 etc.
>>> In order to support USB phy drivers on these SOCs, existing
>>> phy driver is split into SOC agnostic common USB phy driver and
>>> tegra2 specific USB phy driver.
>>> This will facilitate easy addition & deletion of phy drivers for
>>> Tegra SOCs.
>>
>> For capitalization/related reasons, I would re-write the commit
>> description as:
>>
>> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
>> In order to support USB PHY drivers on these SoCs, existing
> 
> Will change tegra2 to Tegra20 and similar for Tegra30 & NVIDIA.
> However as phy is not an acronym, should we still have it in Caps?

I'd certainly expect to see PHY in all-caps, yes. As entirely arbitrary
justification, see the precedent at:

https://en.wikipedia.org/wiki/PHY_(chip)

Sorry for bike-shedding, but I'm picky about that kind of thing, at
least sometimes.

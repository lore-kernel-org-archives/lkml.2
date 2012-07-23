Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2GWO4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:56:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41477 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2GWO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:56:07 -0400
Message-ID: <500D6602.6070809@linaro.org>
Date: Mon, 23 Jul 2012 15:56:02 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Help request - ASoC recursion issue
References: <500D5A1F.9000808@linaro.org> <500D649B.80704@linaro.org>
In-Reply-To: <500D649B.80704@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/12 15:50, Lee Jones wrote:
>> I was wondering if I may bother you for some help. I've been having
>> serious issues with testing the new mop500 sound system you have in your
>> ASoC for-next branch. I've fixed a few issues and will be submitting
>> patches shortly. The most serious issue I came across was with
>> recursion.
>
> It appears you can ignore this. I just tried another piece of hardware
> and this problem doesn't arise, leading me to believe I have some kind
> of eMMC corruption error going on with one of my boards.

FYI, just so you don't think I'm mad: http://paste.ubuntu.com/1106535/

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

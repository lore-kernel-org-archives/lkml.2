Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2FKLVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:21:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43531 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab2FKLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:21:03 -0400
Message-ID: <4FD5D49C.6070106@linaro.org>
Date: Mon, 11 Jun 2012 12:21:00 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/22] regulator: Change db8500-prcmu match names to reflect
 Device Tree
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org> <1338353260-10097-10-git-send-email-lee.jones@linaro.org> <4FCDDE58.5010501@linaro.org> <20120605102900.GP23408@opensource.wolfsonmicro.com> <4FCDE0A4.8070107@linaro.org> <20120605104201.GR23408@opensource.wolfsonmicro.com>
In-Reply-To: <20120605104201.GR23408@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/12 11:42, Mark Brown wrote:
> On Tue, Jun 05, 2012 at 11:34:12AM +0100, Lee Jones wrote:
>
>>>> Are you sending this for -rc2?
>
>>> No, nothing about this looks like an urgent fix?
>
>> Well without it all regulator requests from DT will fail.
>
> Oh, ffs.  Why wasn't this mentioned when the patch was posted,

I did. My 00 patch mentioned that these were all clean-ups/bug fixes 
destined for the for RCs.

> and how were the original patches tested?

So it looks like this may have been my fault when testing the patch-set 
before this one. There are some hacks required to test Device Tree with 
Snowball at the moment, as the u-boot we use isn't DT compatible yet. I 
_may_ have (i.e. my best guess is that I) tested the patch-set in it's 
purest form, thus omitting the ARM_APPENDED_DTB_FILE hack required to 
append the DTB onto the kernel. Without it, the kernel just boots using 
the original platform code.

A genuine mistake on my part for which I unreservedly apologise.

Nevertheless, these two patches are required for a decent boot.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

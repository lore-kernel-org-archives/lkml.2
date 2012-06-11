Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2FKOuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:50:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59165 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2FKOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:50:33 -0400
Message-ID: <4FD605B5.2060300@linaro.org>
Date: Mon, 11 Jun 2012 15:50:29 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/22] regulator: Change db8500-prcmu match names to reflect
 Device Tree
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org> <1338353260-10097-10-git-send-email-lee.jones@linaro.org> <4FCDDE58.5010501@linaro.org> <20120605102900.GP23408@opensource.wolfsonmicro.com> <4FCDE0A4.8070107@linaro.org> <20120605104201.GR23408@opensource.wolfsonmicro.com> <4FD5D49C.6070106@linaro.org> <20120611120820.GN11439@opensource.wolfsonmicro.com> <4FD5F3D2.2050500@linaro.org> <4FD5FBAF.1060002@linaro.org> <20120611142752.GS11439@opensource.wolfsonmicro.com>
In-Reply-To: <20120611142752.GS11439@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 15:27, Mark Brown wrote:
> On Mon, Jun 11, 2012 at 03:07:43PM +0100, Lee Jones wrote:
>>>> Well, I guess I'll end up dulplicating the commits :/
>
>>> Duplicating them?
>
>> Ah, you mean that you've already sent them to -next?
>
> Yeah, I've already got them on a branch I don't really want to rebase.

Ah I see. Makes sense.

>> That's no problem though. Won't Git just sling them out at pull-time?
>
> It'll merge out fine, it's just icky having the same thing appear twice
> in history.  Not the end of the world.

Understood. So does this mean you will to push them into the -rcs?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361Ab2ERHwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:52:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40142 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854Ab2ERHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:52:53 -0400
Message-ID: <4FB5FFD0.4050708@linaro.org>
Date: Fri, 18 May 2012 08:52:48 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] regulator: Enable the ab8500 for Device Tree
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org> <1337262323-27692-12-git-send-email-lee.jones@linaro.org> <20120518073648.GD4073@opensource.wolfsonmicro.com>
In-Reply-To: <20120518073648.GD4073@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/12 08:36, Mark Brown wrote:
> On Thu, May 17, 2012 at 02:45:16PM +0100, Lee Jones wrote:
>> Here we setup the ab8500 regulator driver for DT. We first do
>> this in the normal way, by providing a match structure during
>> initialisation, but then we provide information so that
>> whilst probing we can use existing data structures to do DT
>> look-ups.
>
> Applied, thanks.  This and your previous patch look really good now!

Cheers Mark. Much obliged.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2FKOHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:07:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2FKOHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:07:48 -0400
Message-ID: <4FD5FBAF.1060002@linaro.org>
Date: Mon, 11 Jun 2012 15:07:43 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/22] regulator: Change db8500-prcmu match names to reflect
 Device Tree
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org> <1338353260-10097-10-git-send-email-lee.jones@linaro.org> <4FCDDE58.5010501@linaro.org> <20120605102900.GP23408@opensource.wolfsonmicro.com> <4FCDE0A4.8070107@linaro.org> <20120605104201.GR23408@opensource.wolfsonmicro.com> <4FD5D49C.6070106@linaro.org> <20120611120820.GN11439@opensource.wolfsonmicro.com> <4FD5F3D2.2050500@linaro.org>
In-Reply-To: <4FD5F3D2.2050500@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Well, I guess I'll end up dulplicating the commits :/
>
> Duplicating them?

Ah, you mean that you've already sent them to -next?

That's no problem though. Won't Git just sling them out at pull-time?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

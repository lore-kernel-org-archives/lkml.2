Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2GEPyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:54:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39265 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab2GEPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:54:36 -0400
Message-ID: <4FF5B8B9.8030200@wwwdotorg.org>
Date: Thu, 05 Jul 2012 09:54:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: Register pinctrl from platform code until
 it's been DT:ed
References: <1341412452-3808-1-git-send-email-lee.jones@linaro.org> <CACRpkdb1rZQWpuUxQoxqg2eYanf4tnm0SmFkQQBwvSuyYV00Gw@mail.gmail.com> <4FF56029.2060007@linaro.org>
In-Reply-To: <4FF56029.2060007@linaro.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 03:36 AM, Lee Jones wrote:
> On 05/07/12 09:55, Linus Walleij wrote:
...
>> There are plenty of
>> examples of how to do this in for example:
>> arch/arm/boot/dts/tegra-seaboard.dts
> 
> I don't see this file anywhere?

It was recently renamed to tegra20-seaboard.dts.

While Tegra doesn't need any AUXDATA for the pinctrl driver specifically
(since we're purely initializing pinctrl from DT now when booting with
DT), we do need AUXDATA for other devices mainly for clocks. You can
find the AUXDATA setup in:

arch/arch/mach-tegra/board-dt-tegra*.c

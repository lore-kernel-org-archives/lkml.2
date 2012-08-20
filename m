Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2HTOyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:54:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61679 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab2HTOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:54:32 -0400
Message-ID: <50324FA3.9030005@gmail.com>
Date: Mon, 20 Aug 2012 16:54:27 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/11] arm: mvebu: add pinctrl support in defconfig
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>	<1344689809-6223-12-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdaF3OuBLC7odWyH5C_EJT9uFq1rYQMh6=kr8PQjvA68sA@mail.gmail.com>
In-Reply-To: <CACRpkdaF3OuBLC7odWyH5C_EJT9uFq1rYQMh6=kr8PQjvA68sA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 04:31 PM, Linus Walleij wrote:
> On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com>  wrote:
>> +CONFIG_PINCTRL_ARMADA_370=y
>> +CONFIG_PINCTRL_ARMADA_XP=y
>
> If the system is not even booting without pinctrl you should
> (IMHO) select these from the machine's Kconfig entry insteaf.

I don't have a strong opinion on this but I think most systems
will boot just fine without pinctrl. The basic stuff is set up
by u-boot. Anyway, I think we should enable pinctrl for each soc
by default.

Sebastian

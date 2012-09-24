Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab2IXUDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:03:17 -0400
Received: from antcom.de ([188.40.178.216]:51900 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831Ab2IXUDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:03:15 -0400
Message-ID: <5060BC7F.2030501@antcom.de>
Date: Mon, 24 Sep 2012 22:03:11 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] gpio-lpc32xx: Fix value handling of gpio_direction_output()
References: <1348130883-11329-1-git-send-email-stigge@antcom.de> <CACRpkdZo5kR+Tyhos_StEFZbw3WHF_RFRknHjtU2Pz4XpFTZCA@mail.gmail.com>
In-Reply-To: <CACRpkdZo5kR+Tyhos_StEFZbw3WHF_RFRknHjtU2Pz4XpFTZCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/12 21:55, Linus Walleij wrote:
>> For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
>> (initial value of output). This patch fixes this by setting the level
>> accordingly.
>>
>> Signed-off-by: Roland Stigge<stigge@antcom.de>
>
> Applied with Alexandre's ACK, should go into stable right?
> So tagging this with Cc: stable and sending for the -rc:s.

Right, thanks!

Roland

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2AAPWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 10:22:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46063 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2AAPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 10:22:36 -0500
Message-ID: <4F007A2F.5010303@gmail.com>
Date: Sun, 01 Jan 2012 09:22:23 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng <b29396@freescale.com>, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de, cjb@laptop.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
References: <1324402840-32451-1-git-send-email-b29396@freescale.com> <1324402840-32451-3-git-send-email-b29396@freescale.com> <CACRpkdbLMW-SXnr6hbpwMqG=-a0wmYtU+YnyR8uLsndUp=UBgQ@mail.gmail.com>
In-Reply-To: <CACRpkdbLMW-SXnr6hbpwMqG=-a0wmYtU+YnyR8uLsndUp=UBgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2012 08:07 AM, Linus Walleij wrote:
> On Tue, Dec 20, 2011 at 6:40 PM, Dong Aisheng <b29396@freescale.com> wrote:
> 
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> This patch provies a common API for driver to use to register pinmux
>> mappings from dts file. It is needed for dt support.
> 
> Overall I feel lost in this discussion due to limited exposure to
> device tree concepts. If I get Stephen Warrens and one of the
> DT people's (Rob, Grant) ACK on this I'll be happy to merge it.
> 
> Until then, I guess it will need to be refined for the next kernel
> cycle.

Yes. As Stephen has commented, this still needs a bit of work on the
binding.

Rob

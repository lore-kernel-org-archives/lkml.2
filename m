Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2GRKnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:43:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47893 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2GRKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:43:49 -0400
Message-ID: <50069361.1080509@linaro.org>
Date: Wed, 18 Jul 2012 11:43:45 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Shawn Guo <shawn.guo@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Deepak Saxena <dsaxena@linaro.org>, linux-next@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
References: <20120717130650.GB27595@sirena.org.uk> <500568D9.10805@linaro.org> <20120717133550.GC4477@opensource.wolfsonmicro.com> <50057058.2060002@linaro.org> <20120717142222.GE4477@opensource.wolfsonmicro.com> <50057C1A.80606@linaro.org> <20120717152001.GF4477@opensource.wolfsonmicro.com> <20120718053341.GA4009@S2100-06.ap.freescale.net> <20120718095937.GB22739@opensource.wolfsonmicro.com> <50069006.8050301@linaro.org> <20120718103311.GG22739@opensource.wolfsonmicro.com>
In-Reply-To: <20120718103311.GG22739@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/12 11:33, Mark Brown wrote:
> On Wed, Jul 18, 2012 at 11:29:26AM +0100, Lee Jones wrote:
>> On 18/07/12 10:59, Mark Brown wrote:
>
>>> It's not the using device tree bit that creates concern for me here,
>>> it's the fact that the board and silicon aren't being separated.
>
>> What's the difference?
>
>>> +- db8500.dtsi       // silicon
>>> \	
>>> +-- snowball.dts    // board
>
> I have glanced at some of this stuff in the past, thanks.  Now think how
> that's working for people when they put the configuration for the
> silicon in the same DT node as the configuration for the board...

Granted, ideally the configuration and silicon description should be 
separated. I don't know that is the case for us yet however. That is 
something I'll enforce when we have a new dts file, which will be coming 
very soon.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



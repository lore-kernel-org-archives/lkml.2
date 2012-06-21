Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab2FURbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:31:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977Ab2FURbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:31:41 -0400
Message-ID: <4FE35A78.60003@wwwdotorg.org>
Date: Thu, 21 Jun 2012 11:31:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <201206211450.35713.arnd@arndb.de> <20120621161459.GY4037@opensource.wolfsonmicro.com> <201206211717.46142.arnd@arndb.de>
In-Reply-To: <201206211717.46142.arnd@arndb.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 11:17 AM, Arnd Bergmann wrote:
> On Thursday 21 June 2012, Mark Brown wrote:
...
>> I'm also not sure if the tooling works well for allowing people to
>> include standard DTs for chips and add new properties to nodes for the
>> board specific configuration, though I think I've seen a few things
>> which suggested that was dealt with reasonably well.
> 
> It should never be necessary to add board-specific properties in the
> nodes that describe the SoC specific bits. What I was referring to
> is just moving the data that currently resides in the regulator
> driver into DT.

I guess I must be misunderstanding that comment - there are many many
examples of boards adding properties to nodes that describe the SoC. For
example, the GPIOs used by SDHCI controllers, board-specific max clock
rates for SDHCI or I2C controllers, pinmux configuration properties, to
name just a few.

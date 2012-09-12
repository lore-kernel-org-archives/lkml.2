Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2ILU5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:57:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47744 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2ILU5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:57:38 -0400
Message-ID: <5050F73D.8050701@wwwdotorg.org>
Date: Wed, 12 Sep 2012 14:57:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 6/9] ARM: mvebu: add pinctrl device in DT for Armada
 370/XP SoCs
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-7-git-send-email-sebastian.hesselbarth@gmail.com> <504FB9D7.3030205@wwwdotorg.org> <20120912085652.21d3232f@skate>
In-Reply-To: <20120912085652.21d3232f@skate>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 12:56 AM, Thomas Petazzoni wrote:
> Le Tue, 11 Sep 2012 16:23:19 -0600,
> Stephen Warren <swarren@wwwdotorg.org> a écrit :
> 
>> On 09/10/2012 02:39 AM, Sebastian Hesselbarth wrote:
>>> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>>>
>>> The Armada 370 and XP SoCs have configurable muxing for a certain
>>> number of their pins, controlled through a pinctrl driver.
>>
>> Hmmm. I'd be tempted just to put the entire node definition there;
>> putting in a .dtsi file just to share the reg property doesn't seem
>> especially useful.
> 
> When you say "here" you're mentioning the SoC-specific .dtsi files (i.e

(s/here/there I assume).

> the ones in PATCH 7/9 and PATCH 8/9), correct?

Yes, I believe so.


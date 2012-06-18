Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2FRPpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:45:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43771 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2FRPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:45:29 -0400
Message-ID: <4FDF4D14.50203@wwwdotorg.org>
Date: Mon, 18 Jun 2012 09:45:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: of_get_named_gpio_flags() return -EPROBE_DEFER
 if GPIO not yet available
References: <1339927893-8842-1-git-send-email-stigge@antcom.de> <4FDE8D27.6030508@wwwdotorg.org> <4FDEF293.9080305@antcom.de> <4FDF403E.9090302@wwwdotorg.org> <4FDF4461.60707@antcom.de> <4FDF4543.6090009@wwwdotorg.org> <4FDF47D8.9000309@antcom.de>
In-Reply-To: <4FDF47D8.9000309@antcom.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 09:23 AM, Roland Stigge wrote:
> On 06/18/2012 05:12 PM, Stephen Warren wrote:
>>> Thanks for the hint! I previously also suspected sth. like this but
>>> didn't find it in v3.5-rc3. In broonie's sound.git for-next, I now
>>> finally found it.
>>>
>>> Should be easy to fix (replacing the if (... == -ENODEV) to -EPROBE_DEFER.
>>>
>>> Will you provide patches as signalled, of should I? Which branch would
>>> be the correct one to build on top?
>>
>> I'm happy either way. It'd probably be best to roll the change into your
>> patch/series so you can manage all the dependencies in one series, but
>> if you can't for some reason, I'm happy to provide a patch for this.
> 
> I should be able ;-) - is broonie's sound.git, branch for-next the
> correct one to patch against?

Yes, that's the one. Thanks.

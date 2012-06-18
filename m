Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2FRPXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:23:10 -0400
Received: from antcom.de ([188.40.178.216]:55101 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2FRPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:23:06 -0400
Message-ID: <4FDF47D8.9000309@antcom.de>
Date: Mon, 18 Jun 2012 17:23:04 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: of_get_named_gpio_flags() return -EPROBE_DEFER
 if GPIO not yet available
References: <1339927893-8842-1-git-send-email-stigge@antcom.de> <4FDE8D27.6030508@wwwdotorg.org> <4FDEF293.9080305@antcom.de> <4FDF403E.9090302@wwwdotorg.org> <4FDF4461.60707@antcom.de> <4FDF4543.6090009@wwwdotorg.org>
In-Reply-To: <4FDF4543.6090009@wwwdotorg.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 05:12 PM, Stephen Warren wrote:
>> Thanks for the hint! I previously also suspected sth. like this but
>> didn't find it in v3.5-rc3. In broonie's sound.git for-next, I now
>> finally found it.
>>
>> Should be easy to fix (replacing the if (... == -ENODEV) to -EPROBE_DEFER.
>>
>> Will you provide patches as signalled, of should I? Which branch would
>> be the correct one to build on top?
> 
> I'm happy either way. It'd probably be best to roll the change into your
> patch/series so you can manage all the dependencies in one series, but
> if you can't for some reason, I'm happy to provide a patch for this.

I should be able ;-) - is broonie's sound.git, branch for-next the
correct one to patch against? Or sth. better suited?

Thanks in advance,

Roland

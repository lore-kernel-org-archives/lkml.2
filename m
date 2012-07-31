Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2GaPP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:15:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44091 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2GaPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:15:26 -0400
Message-ID: <5017F68B.3060400@linaro.org>
Date: Tue, 31 Jul 2012 16:15:23 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-3-git-send-email-lee.jones@linaro.org> <20120731134214.GK4468@opensource.wolfsonmicro.com> <5017EAC3.3080504@linaro.org> <20120731142820.GW4468@opensource.wolfsonmicro.com> <5017EDCA.4020601@linaro.org> <20120731145443.GY4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731145443.GY4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 15:54, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 03:38:02PM +0100, Lee Jones wrote:
>
>> Neither of those are in my Inbox. Blame Mozilla. :)
>
> You might want to look at a better mail program.

Willingly. Any good suggestions?

>> It's better because the whole audio system doesn't fail in the case
>> of minor failure. It'd be like calling off a football game (or
>> whatever you're into) because one of the substitutes ruptured an
>> eyelash.
>
> It shouldn't make any difference to startup - we should still be
> checking errors and failing the init if we're failing to add links,
> this isn't something that's likely to randomly break on a particular
> boot, it's more something that indicates nobody bothered testing.
>
> It's certainly totally inappropriate for an "urgent" bugfix.

Well it just means that audio won't work for the ux500 for this kernel 
release, but as we're waiting on clocks, this isn't a big issue for us. 
If you do take it (with or without the return code), feel free to add it 
to for-next instead of the -rc:s

>> During start-up the ux500 has a couple of very unimportant widgets
>> fail. It's the wrong behavior to force failure on the everything
>> audio just because of that.
>
> Fixes for those errors, however...

I'll leave that to the audio expert. I'd like to move to to something 
else (that you maintain - perhaps I'll go and mess-up regulators next). :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

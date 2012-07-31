Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2GaOiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:38:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50179 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2GaOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:38:05 -0400
Message-ID: <5017EDCA.4020601@linaro.org>
Date: Tue, 31 Jul 2012 15:38:02 +0100
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
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-3-git-send-email-lee.jones@linaro.org> <20120731134214.GK4468@opensource.wolfsonmicro.com> <5017EAC3.3080504@linaro.org> <20120731142820.GW4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731142820.GW4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 15:28, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 03:25:07PM +0100, Lee Jones wrote:
>> On 31/07/12 14:42, Mark Brown wrote:
>
>>> You're posting this *again* without bothering to respond to my review
>>> comments.
>
>> I didn't see any comments on this.
>
> Read your email.  <20120726115450.GE3099@opensource.wolfsonmicro.com>
> and <20120729202510.GB4384@opensource.wolfsonmicro.com>, the second one
> even includes a complaint about you ignoring the first mail.

Neither of those are in my Inbox. Blame Mozilla. :)

It's better because the whole audio system doesn't fail in the case of 
minor failure. It'd be like calling off a football game (or whatever 
you're into) because one of the substitutes ruptured an eyelash.

During start-up the ux500 has a couple of very unimportant widgets fail. 
It's the wrong behavior to force failure on the everything audio just 
because of that.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

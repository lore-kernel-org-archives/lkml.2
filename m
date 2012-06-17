Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2FQLvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 07:51:09 -0400
Received: from antcom.de ([188.40.178.216]:37272 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab2FQLvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 07:51:08 -0400
Message-ID: <4FDDC4A9.1040706@antcom.de>
Date: Sun, 17 Jun 2012 13:51:05 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: riku.voipio@iki.fi, bryan.wu@canonical.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] leds: Add DT support for leds-pca9532
References: <1339855851-9171-1-git-send-email-stigge@antcom.de> <4FDCA0FC.5000409@wwwdotorg.org>
In-Reply-To: <4FDCA0FC.5000409@wwwdotorg.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16/06/12 17:06, Stephen Warren wrote:
>> +- nxp,typecodes: groups of 2 bits for each of the 16 pins:
>> +  0: None
>> +  1: LED
>> +  2: Beep
>> +  3: GPIO
>> +- nxp,statecodes: groups of 2 bits for each of the 16 pins:
>> +  0: off
>> +  1: on
>> +  2: pwm0
>> +  3: pwm1
>> +
>> +Optional properties:
>> +- nxp,psc: array of 2 numbers: PSC values for the two PWM channels (see datasheet)
>> +- nxp,pwm: array of 2 numbers: PWM values for the two PWM channels (see datasheet)
> 
> Shouldn't that all be exposed using a combination of the pinctrl
> bindings that are in 3.5, and the PWM bindings that should be coming in 3.6?

Thanks for the note! I found a pwm tree that should have this at

http://gitorious.org/linux-pwm/linux-pwm

but it gives me server errors. Is there a place where I can have a look?

Thanks in advance,

Roland

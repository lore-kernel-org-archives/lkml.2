Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1EYMMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:12:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33701 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab1EYMMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:12:09 -0400
Message-ID: <4DDCF20B.4080701@ti.com>
Date: Wed, 25 May 2011 13:11:55 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoc: wm8731: fix wm8731_check_osc() connected condition
References: <1306230657-28649-1-git-send-email-nicolas.ferre@atmel.com> <20110525111529.GC10797@opensource.wolfsonmicro.com>
In-Reply-To: <20110525111529.GC10797@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/11 12:15, Mark Brown wrote:
> On Tue, May 24, 2011 at 11:50:57AM +0200, Nicolas Ferre wrote:
>> The crystal oscillator is only enabled if the WM8731_SYSCLK_XTAL master clock
>> is specified. Fix the connected() struct snd_soc_dapm_route function to take
>> this into account. Oscillator is not enabled on machine that need it otherwise.
>>
>> Machine drivers have to make sure that they use the proper SYSCLK value.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Adding Liam - Nicolas, please remember to CC all maintainers on patches.
> 

Acked-by: Liam Girdwood <lrg@ti.com>

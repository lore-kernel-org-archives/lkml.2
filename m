Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1EYMVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:21:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38442 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab1EYMVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:21:53 -0400
Message-ID: <4DDCF453.3070805@ti.com>
Date: Wed, 25 May 2011 13:21:39 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoc: sam9g20_wm8731: use the proper SYSCKL value
References: <1306230676-28688-1-git-send-email-nicolas.ferre@atmel.com> <20110525111545.GD10797@opensource.wolfsonmicro.com>
In-Reply-To: <20110525111545.GD10797@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/11 12:15, Mark Brown wrote:
> On Tue, May 24, 2011 at 11:51:16AM +0200, Nicolas Ferre wrote:
>> at91sam9g20 is providing master clock to wm8731: not using a crystal but an
>> external MCLK. We can avoid conflict and save power using WM8731_SYSCLK_MCLK as
>> we do not need oscillator to be powered.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Adding Liam.
> 

Acked-by: Liam Girdwood <lrg@ti.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1GDJrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:47:05 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56523 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1GDJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:47:02 -0400
Message-ID: <4E118BF6.6010205@atmel.com>
Date: Mon, 04 Jul 2011 11:46:30 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com
CC: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8731: set the ACTIVE bit if bias ON entered
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com> <20110701161506.GC23784@opensource.wolfsonmicro.com>
In-Reply-To: <20110701161506.GC23784@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/07/2011 18:15, Mark Brown :
> On Fri, Jul 01, 2011 at 12:43:54PM +0200, Nicolas Ferre wrote:
>> Resuming from a suspend/resume cycle, the ACTIVE bit was not set even if a
>> stream had actually been processing.
>> Setting this bit at entering SND_SOC_BIAS_ON level will ensure this.
> 
> This will set the bit even for analogue bypass paths which don't need
> it.  I'd suggest making the active bit a supply widget supplying the DAC
> and ADC rather than something open coded, that should do the right thing
> I think.

Ah, ok... but I fear that I do not know the whole system enough for this
addition ;-(
Do you think you can code this modification, I will be happy to test it,
if you want...

Best regards,
-- 
Nicolas Ferre


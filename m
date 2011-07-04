Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab1GDRe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:34:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48038 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab1GDRe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:34:26 -0400
Message-ID: <4E11F992.6080506@ti.com>
Date: Mon, 4 Jul 2011 18:34:10 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: wm8731: set the ACTIVE bit if bias ON entered
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com> <20110701161506.GC23784@opensource.wolfsonmicro.com> <4E118BF6.6010205@atmel.com> <20110704172856.GF28726@opensource.wolfsonmicro.com>
In-Reply-To: <20110704172856.GF28726@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/11 18:29, Mark Brown wrote:
> On Mon, Jul 04, 2011 at 11:46:30AM +0200, Nicolas Ferre wrote:
> 
>> Ah, ok... but I fear that I do not know the whole system enough for this
>> addition ;-(
>> Do you think you can code this modification, I will be happy to test it,
>> if you want...
> 
> It's pretty trivial - try the below (Liam, are you OK with this if it
> tests OK?):
> 

All fine by me, It's been so long I've forgotten most things about the WM8731 now ;)


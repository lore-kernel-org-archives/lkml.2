Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab0HYOqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:46:13 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:59585 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0HYOqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:46:11 -0400
X-Greylist: delayed 2835 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 10:46:11 EDT
Message-ID: <4C752197.5000704@iki.fi>
Date: Wed, 25 Aug 2010 16:58:47 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] af9015: add USB ID for Terratec Cinergy T Stick RC MKII
References: <201008251508.51379.s.L-H@gmx.de>
In-Reply-To: <201008251508.51379.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.188.60
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heissan Stefan,

On 08/25/2010 04:08 PM, Stefan Lippers-Hollmann wrote:
> Adding the USB ID for my TerraTec Electronic GmbH Cinergy T RC MKII
> [0ccd:0097] and hooking it up into af9015, on top of your new NXP TDA18218
> patches, makes it work for me.

Patch is OK, I have just similar patch waiting here...

Acked-by: Antti Palosaari <crope@iki.fi>

I have been waiting Mauro commit for TDA18218 driver which I send about 
2 weeks ago. And few others too for the MXL5007T based devices. Mauro 
when you will commit TDA18218?

> Just the shipped IR remote control doesn't seem to create keycode events
> yet (tested with different remote=%d parameters), are there any hints to
> add support for that?

My next plan is to move that remote controller to the new remote core 
system. I have done some tests and I can now read out raw remote codes 
from the device. Before that you can add keymap for that remote. There 
is many ways to get keycodes; 1) USB-sniff, 2) dump from Windows driver, 
3) read from af9015 memory, 4) use some other IR receiver...

regards
Antti

> Signed-off-by: Stefan Lippers-Hollmann<s.l-h@gmx.de>
> ---
>
> This depends on the git pull request "NXP TDA18218 silicon tuner driver"
> from Antti Palosaari<crope@iki.fi>  and does not apply to -stable:
>   * NXP TDA18218 silicon tuner driver
>   * af9013: add support for tda18218 silicon tuner
>   * af9015: add support for tda18218 silicon tuner

-- 
http://palosaari.fi/

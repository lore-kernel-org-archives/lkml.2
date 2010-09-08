Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0IHO2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0IHO2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:28:11 -0400
Message-ID: <4C879D70.5050600@redhat.com>
Date: Wed, 08 Sep 2010 11:28:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] af9015: add USB ID for Terratec Cinergy T Stick RC MKII
References: <201008251508.51379.s.L-H@gmx.de> <4C752197.5000704@iki.fi>
In-Reply-To: <4C752197.5000704@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-08-2010 10:58, Antti Palosaari escreveu:
> Heissan Stefan,
> 
> On 08/25/2010 04:08 PM, Stefan Lippers-Hollmann wrote:
>> Adding the USB ID for my TerraTec Electronic GmbH Cinergy T RC MKII
>> [0ccd:0097] and hooking it up into af9015, on top of your new NXP TDA18218
>> patches, makes it work for me.
> 
> Patch is OK, I have just similar patch waiting here...
> 
> Acked-by: Antti Palosaari <crope@iki.fi>
> 
> I have been waiting Mauro commit for TDA18218 driver which I send about 2 weeks ago. And few others too for the MXL5007T based devices. Mauro when you will commit TDA18218?

I've committed it this week.  Sorry for being late about that. I was very busy
with some other pending work. 

This patch caused a minor merge conflict. I just fixed it and merged it on my tree.

> 
>> Just the shipped IR remote control doesn't seem to create keycode events
>> yet (tested with different remote=%d parameters), are there any hints to
>> add support for that?
> 
> My next plan is to move that remote controller to the new remote core system. 
> I have done some tests and I can now read out raw remote codes from the device.

That's great news. 

> Before that you can add keymap for that remote. There is many ways to get keycodes; 
> 1) USB-sniff, 2) dump from Windows driver, 3) read from af9015 memory, 4) use some other IR receiver...
> 
> regards
> Antti
> 
>> Signed-off-by: Stefan Lippers-Hollmann<s.l-h@gmx.de>
>> ---
>>
>> This depends on the git pull request "NXP TDA18218 silicon tuner driver"
>> from Antti Palosaari<crope@iki.fi>  and does not apply to -stable:
>>   * NXP TDA18218 silicon tuner driver
>>   * af9013: add support for tda18218 silicon tuner
>>   * af9015: add support for tda18218 silicon tuner
> 


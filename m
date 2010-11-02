Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0KBTxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:53:20 -0400
Received: from mailout1.go2.pl ([193.17.41.11]:58573 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0KBTxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:53:18 -0400
Message-ID: <4CD06C22.20204@o2.pl>
Date: Tue, 02 Nov 2010 20:53:06 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [W1] a driver for DS2405 chip
References: <4CC9E2A5.2010400@o2.pl> <4CCEB42F.8000102@cam.ac.uk>
In-Reply-To: <4CCEB42F.8000102@cam.ac.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 66
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 01.11.2010 13:35, Jonathan Cameron pisze:
> On 10/28/10 21:52, Maciej Szmigiero wrote:
>> [W1] a driver for DS2405 chip
>>
>> This is a driver for DS2405 1-wire single-channel addressable switch / PIO.
>> DS2405 can also work as single-channel binary remote sensor.
> Perhaps handle this as a gpio chip? (be it a fairly limited one)
> To my mind it would make it more generally useful...

I think the GPIO infrastructure is meant for on-system GPIOs, where 1-wire devices are mostly 
used for remote data acquisition.
That's probably why w1_therm (for 1-wire thermometers) is not integrated with HWMON subsystem.

Maciej Szmigiero

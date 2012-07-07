Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2GGGst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 02:48:49 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:58022 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776Ab2GGGsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 02:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120706232737.GA18598@kroah.com>
References: <1341355030-20800-1-git-send-email-eduardo.valentin@ti.com>
	<1341355030-20800-2-git-send-email-eduardo.valentin@ti.com>
	<20120706232737.GA18598@kroah.com>
Date: Sat, 7 Jul 2012 09:48:45 +0300
Message-ID: <CAGF5oy88n=7dJKfc0xEeh4GFivzXZYTtN-udbxpchdWou9Gp_Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, j-keerthy@ti.com,
        grant.likely@secretlab.ca, b-cousson@ti.com, kbaidarov@dev.rtsoft.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Sat, Jul 7, 2012 at 2:27 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 04, 2012 at 01:37:07AM +0300, Eduardo Valentin wrote:
>> In the System Control Module, OMAP supplies a voltage reference
>> and a temperature sensor feature that are gathered in the band
>> gap voltage and temperature sensor (VBGAPTS) module. The band
>> gap provides current and voltage reference for its internal
>> circuits and other analog IP blocks. The analog-to-digital
>> converter (ADC) produces an output value that is proportional
>> to the silicon temperature.
>>
>> This patch provides a platform driver which expose this feature.
>> It is moduled as a MFD child of the System Control Module core
>> MFD driver.
>>
>> This driver provides only APIs to access the device properties,
>> like temperature, thresholds and update rate.
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>  drivers/staging/Kconfig                       |    2 +
>>  drivers/staging/Makefile                      |    1 +
>
> By not including the files these files "include" you just broke the
> build at this point in the patch series, which isn't good.
>
> Care to redo this series, so that it can build at each step of the way
> (you might do this by just adding the Kconfig and Makefile entries as
> the last patch), and then I will be glad to apply it to the tree.

Yeah. Indeed. My bad. I will resend the worked series.

>
> Oh, and yes, this implies that I have no problem taking this driver for
> the staging tree :)

Cool!

>
> thanks,
>
> greg k-h



-- 

Eduardo Valentin

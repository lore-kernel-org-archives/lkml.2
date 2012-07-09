Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2GIUdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:33:24 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57353 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182Ab2GIUdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120709193130.GA12982@kroah.com>
References: <1341647872-15267-1-git-send-email-eduardo.valentin@ti.com>
	<1341647872-15267-2-git-send-email-eduardo.valentin@ti.com>
	<20120709193130.GA12982@kroah.com>
Date: Mon, 9 Jul 2012 23:33:20 +0300
Message-ID: <CAGF5oy_QVyYKFcS_62dffkRRZhBZrG4RTpYG9HKT8zMoLue1Xw@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Mon, Jul 9, 2012 at 10:31 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Jul 07, 2012 at 10:57:49AM +0300, Eduardo Valentin wrote:
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
>
> As much as I enjoy interesting names, odds are, "Keerthy" is not the
> real name of this person, right?  In fact, based on the copyright
> comments in the code, I can almost guarantee it...
>
> I need a full-name please, no aliases or fake names allowed in kernel
> signed-off-by lines.
>
> Please resend these with that fixed up.

Actually, his name is in fact Keerthy J.  I can resend with the
additional "J" the way it is in the copyrights.

>
> greg k-h



-- 

Eduardo Valentin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226Ab2GLPgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:36:39 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:51308 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161207Ab2GLPgh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:36:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120712153452.GC17365@kroah.com>
References: <1342039269-13968-1-git-send-email-eduardo.valentin@ti.com>
	<1342039269-13968-2-git-send-email-eduardo.valentin@ti.com>
	<20120712003216.GA9827@kroah.com>
	<CAGF5oy8585Lb6ibsgzo+3aDJEc-vcRwiu4hxtNS=GFUEy7LDqQ@mail.gmail.com>
	<20120712153452.GC17365@kroah.com>
Date: Thu, 12 Jul 2012 18:36:32 +0300
Message-ID: <CAGF5oy_3qWw0L8D22E1cEpHSV4Q++J++8dUb-n366SenjqyvuQ@mail.gmail.com>
Subject: Re: [PATCHv3 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 12, 2012 at 6:34 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jul 12, 2012 at 05:45:52AM +0300, Valentin, Eduardo wrote:
>> Hello,
>>
>> On Thu, Jul 12, 2012 at 3:32 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Jul 11, 2012 at 11:41:06PM +0300, Eduardo Valentin wrote:
>> >> In the System Control Module, OMAP supplies a voltage reference
>> >> and a temperature sensor feature that are gathered in the band
>> >> gap voltage and temperature sensor (VBGAPTS) module. The band
>> >> gap provides current and voltage reference for its internal
>> >> circuits and other analog IP blocks. The analog-to-digital
>> >> converter (ADC) produces an output value that is proportional
>> >> to the silicon temperature.
>> >>
>> >> This patch provides a platform driver which expose this feature.
>> >> It is moduled as a MFD child of the System Control Module core
>> >> MFD driver.
>> >>
>> >> This driver provides only APIs to access the device properties,
>> >> like temperature, thresholds and update rate.
>> >>
>> >> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> >> Signed-off-by: J Keerthy <j-keerthy@ti.com>
>> >
>> > This patch gives me the following build error:
>> >
>> > rivers/staging/omap-thermal/omap-bandgap.c: In function ‘omap_bandgap_build’:
>> > drivers/staging/omap-thermal/omap-bandgap.c:805:2: error: implicit declaration of function ‘of_match_device’ [-Werror=implicit-function-declaration]
>> > drivers/staging/omap-thermal/omap-bandgap.c:805:8: warning: assignment makes pointer from integer without a cast [enabled by default]
>>
>> OK. Those I didn't see while testing on my side. I didn't use
>> -Werror=implicit-function-declaration though.
>
> You shouldn't need to do that, just build this driver on your desktop
> and you will see the error (hint, do you really want to build this on
> x86-64 platforms?)

Yeah, we shouldnt allow it. I will limit its compilation to omap only on v4.

>
> thanks,
>
> greg k-h



-- 

Eduardo Valentin

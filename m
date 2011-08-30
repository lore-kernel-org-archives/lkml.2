Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1H3GRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:17:13 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:50722 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab1H3GRL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:17:11 -0400
MIME-Version: 1.0
In-Reply-To: <8739gkrllg.fsf@ti.com>
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-4-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
	<87mxesrr1g.fsf@ti.com>
	<8739gkrllg.fsf@ti.com>
Date: Tue, 30 Aug 2011 11:47:08 +0530
Message-ID: <CAP05o4+cmLWu6e36mkzED1X2f=seS9urXva2dRk5dTLWCBZ9FQ@mail.gmail.com>
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        "Balbi, Felipe" <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gadiyar@ti.com, parthab@india.ti.com,
        tony@atomide.com, b-cousson@ti.com, paul@pwsan.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 2:17 AM, Kevin Hilman <khilman@ti.com> wrote:
> Kevin Hilman <khilman@ti.com> writes:
>
>> Keshava Munegowda <keshava_mgowda@ti.com> writes:
>>
>>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>>
>>> The usbhs core driver does not enable/disable the intefrace and
>>> fucntional clocks; These clocks are handled by hwmod and runtime pm,
>>> hence insted of the clock enable/disable, the runtime pm APIS are
>>> used. however,the port clocks are handled by the usbhs core.
>>>
>>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>>
>> General comment: all usage of pm_runtime_put_sync() can likely be
>> replaced by the asynchronous versions.  I don't currently see why the
>> synchronous verions are needed here.
>>
>> Other than that, the runtime PM parts of this look OK to me.  After
>> changing to asynchonous puts, feel free to add:
>>
>> Reviewed-by: Kevin Hilman <khilman@ti.com>
>
> oops, this should've been in response to your v8 version.
>
> Kevin
>
>>
>> Also, after a quick glance, it looks like this version of the series
>> addresses the problems seen by Jassi Brar with the TLL reset[1].  Please
>> confirm.
>>
>> Speaking of which, it's helpful to Cc folks who have had comments on
>> previous versions of your series so they are sure they're previous
>> issues are addressed.   I've Cc'd Jassi Brar.
>>
>> Thanks,
>>
>> Kevin
>>
>> [1] http://marc.info/?l=linux-omap&m=130921260703865&w=2
>

Thanks for review;  yes, its reworks of complete runtime pm of usbhs as
suggested by Jassi Brar.

balbi, sameo
         this patch series available at

the branch kmg-usbhs-pm

of code repository : git://gitorious.org/~kmg/mirrors/kmg-usbhs-pm.git

Regards
Keshava

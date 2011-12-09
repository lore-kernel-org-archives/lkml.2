Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1LIHZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:25:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44941 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1LIHZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:25:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111209061720.GF26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
	<1323361659-11835-3-git-send-email-thomas.abraham@linaro.org>
	<20111209061720.GF26952@opensource.wolfsonmicro.com>
Date: Fri, 9 Dec 2011 12:55:33 +0530
Message-ID: <CAJuYYwSS0-+=D3WbwYDowZQTrFq_s1XEM_gSkgXApstPeGNWkA@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2011 11:47, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Dec 08, 2011 at 09:57:39PM +0530, Thomas Abraham wrote:
>
>> +Required properties, if interrupts are delivered to host system:
>
> These are just optional properties, really.

Ok. Yeah, these can be classified as optional.

>
>> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
>> +  the interrupts from max8997 are delivered to.
>> +- interrupts: Interrupt specifiers for two interrupt sources.
>> +  - First interrupt specifier is for 'irq1' interrupt.
>> +  - Second interrupt specifier is for 'alert' interrupt.
>
> What if the two are connected to different interrupt controllers?

I have not thought of that. I will try to find out how to write a
device tree node for a device that delivers interrupts to separate
interrupt controllers.

Thanks,
Thomas.

>
>> +    For LDO's:
>
> Extra '.

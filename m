Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1KGGXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:23:48 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:35998 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab1KGGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:23:47 -0500
Message-ID: <4EB77968.803@ti.com>
Date: Mon, 07 Nov 2011 11:53:36 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract regulator_init_data
References: <1319721864-30067-1-git-send-email-rnayak@ti.com> <20111104202905.GA3918@quad.lixom.net>
In-Reply-To: <20111104202905.GA3918@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Saturday 05 November 2011 01:59 AM, Olof Johansson wrote:
>> +- regulator-min-uV: smallest voltage consumers may set
>> >  +- regulator-max-uV: largest voltage consumers may set
>> >  +- regulator-uV-offset: Offset applied to voltages to compensate for voltage drops
>> >  +- regulator-min-uA: smallest current consumers may set
>> >  +- regulator-max-uA: largest current consumers may set
>> >  +- regulator-always-on: boolean, regulator should never be disabled
>> >  +- regulator-boot-on: bootloader/firmware enabled regulator
 >
> Once you have a compatible field that can determine what kind of device node,
> and binding, this is, you can drop the regulator- prefix and save some space in
> the device tree. Properties are rarely prefixed by their subsystem. Only
> exception would/could be the regulator-name property where it could make
> sense to keep the prefix.

given that we decided not to have a compatible field like "regulator"
for the top-level bindings and instead have a device specific one,
and based on the discussions with Grant here[1], I hope its OK to keep
these the way they are.

regards,
Rajendra

[1] 
http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-September/008196.html

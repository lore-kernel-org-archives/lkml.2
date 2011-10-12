Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1JLIQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:16:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40092 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1JLIQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:16:32 -0400
Message-ID: <4E954CDA.10107@ti.com>
Date: Wed, 12 Oct 2011 10:16:26 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com> <4E936F0E.9050203@ti.com> <alpine.DEB.2.00.1110101725140.5205@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1110101725140.5205@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 1:26 AM, Paul Walmsley wrote:
> On Tue, 11 Oct 2011, Cousson, Benoit wrote:
>
>> In fact the device name does not have to match the hwmod name. So we can just
>> create an "omap2_prm" omap_device for OMAP2, "omap3_prm" omap_device for
>> OMAP3...
>> That will allow the relevant PRM  driver to be bound to the proper device.
>
> Incidentally, given that we would be using the hwmod name and the version
> number to determine the appropriate omap_device name, what IP version
> numbers should we assign to these PRM IP blocks for different SoCs?

It can just be 1, 2 and 3... The idea is just to differentiate the IP 
for each OMAP.

Regards,
Benoit


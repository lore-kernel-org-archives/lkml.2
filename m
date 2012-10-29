Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab2J2IEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:04:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49862 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab2J2IEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:04:38 -0400
Message-ID: <508E3857.6080109@ti.com>
Date: Mon, 29 Oct 2012 13:33:35 +0530
From: Afzal Mohammed <x0148406@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <rtc-linux@googlegroups.com>
Subject: Re: [PATCH v4 3/5] rtc: omap: dt support
References: <cover.1350633036.git.afzal@ti.com> <061c670b0a05570d7b83d8a8f105ee5b35583f7f.1350633036.git.afzal@ti.com> <5084523F.2070800@gmail.com>
In-Reply-To: <5084523F.2070800@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Monday 22 October 2012 01:21 AM, Daniel Mack wrote:
> On 19.10.2012 11:59, Afzal Mohammed wrote:

>> +static const struct of_device_id omap_rtc_of_match[] = {
>> +	{	.compatible	= "ti,da830-rtc",
>> +		.data		=&omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],

> Wouldn't it make sense to list all the compatible models here? The
> advantage of a compatible list is that we can name the models
> explicitly, or maybe at least "davinci-rtc". Is there any reason for
> this particular name?

Exact name followed by compatible models needs to be
specified in DT node only, right ? (when driver for the
first variant can handle it)

And when additional features of newer IP's has to be
leveraged, new entries can be added in the driver
match table.

First known variant of SoC for DT is da830 (exact name),
hence it was used.

Regards
Afzal


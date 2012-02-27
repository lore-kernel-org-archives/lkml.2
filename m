Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2B0KOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:14:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2B0KOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:14:15 -0500
Message-ID: <4F4B5772.5000003@ti.com>
Date: Mon, 27 Feb 2012 11:14:10 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mfd: twl-core: Add IRQ_DOMAIN dependency
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca> <1330102448-19172-2-git-send-email-grant.likely@secretlab.ca> <20120227101758.GI27687@sortiz-mobl>
In-Reply-To: <20120227101758.GI27687@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/2012 11:17 AM, Samuel Ortiz wrote:
> Hi Grant, Benoit,
>
> On Fri, Feb 24, 2012 at 09:54:08AM -0700, Grant Likely wrote:
>> From: Benoit Cousson<b-cousson@ti.com>
>>
>> TWL4030 depends on IRQ_DOMAIN support, so this patch selects it in Kconfig.
>> It used to be that CONFIG_IRQ_DOMAIN must only be selected by the architecture,
>> but recent cleanups have fixed it so that it is safe to select from anywhere.
> Applied to my for-next branch, thanks.

Thanks Samuel,

Regards,
Benoit

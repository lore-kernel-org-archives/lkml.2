Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2E3PYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:24:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50976 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2E3PYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:24:10 -0400
Message-ID: <4FC63B8D.3070107@ti.com>
Date: Wed, 30 May 2012 17:23:57 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <paul@pwsan.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [RFC PATCH 2/5] arm: omap: remove ocp2scp_usb_phy_ick clock node
References: <1338375394-16268-1-git-send-email-kishon@ti.com> <1338375394-16268-3-git-send-email-kishon@ti.com> <CAMQu2gxcP8At5j4UOK3bgX+Q+OunXeTxyXEr6hAhGiwjLs-gJg@mail.gmail.com>
In-Reply-To: <CAMQu2gxcP8At5j4UOK3bgX+Q+OunXeTxyXEr6hAhGiwjLs-gJg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/2012 4:51 PM, Shilimkar, Santosh wrote:
> On Wed, May 30, 2012 at 4:26 PM, Kishon Vijay Abraham I<kishon@ti.com>  wrote:
>> "ocp2scp_usb_phy_ick" clock node was a fake clock node created
>> to control MODULEMODE of ocp2scp. Since the hwmod for ocp2scp is now added
>> (which can be used to control MODULEMODE) this clock node is removed.
>>
>> Cc: Benoit Cousson<b-cousson@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>> ---
>>   arch/arm/mach-omap2/clock44xx_data.c |   11 -----------
>
> Have you patched clock44xx_data.c manually or you have a patch for
> the clock_data autogen script to generate it ?

I have a series that will remove all these clock nodes. I should be able 
to post that soon.

Potentially at that time, Kishon might be able to drop that patch.

Regards,
Benoit


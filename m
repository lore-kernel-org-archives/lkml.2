Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2GBLxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:53:31 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38947 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886Ab2GBLxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:53:30 -0400
Message-ID: <4FF18BB1.3050503@ti.com>
Date: Mon, 02 Jul 2012 17:23:21 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Wolfram Sang <w.sang@pengutronix.de>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/17] Big OMAP I2C Cleanup
References: <1339691067-919-1-git-send-email-balbi@ti.com> <20120614175950.GE14419@pengutronix.de> <4FE99432.8030300@ti.com> <20120702113712.GB2730@arwen.pp.htv.fi>
In-Reply-To: <20120702113712.GB2730@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 05:07 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jun 26, 2012 at 04:21:30PM +0530, Shubhrajyoti wrote:
>> On Thursday 14 June 2012 11:29 PM, Wolfram Sang wrote:
>>>> 	- removed dev_err() which was introduced on patch 09/17
>>> To prevent the list being flooded, I would appreciate if you could wait
>>> a few days to collect reviews before resending. It will take some time
>>> until I pick this series anyhow, because I want people to have time to
>>> donate Tested-by tags.
>> Felipe thats a good cleanup.
>> The series look good to me.
>>
>> Also draining interrupt I had some queries.
>> Looks good to me.
>>
>> I have tested it after rebasing.
> rebasing on top of what ? 
On top of embedded i2c branch of Wolfram.

> You should resend the series so that I know
> what changes you have made to my original patchset. Make sure to list on
> the commit log what where the changes you made, so that it looks
> something like this commit below where I changed commit log a bit:
Will do that.
Thanks,

> | commit 3daf74d78dfcd552445c35f1b82a271ca305ceb9
> | Author: Pratyush Anand <pratyush.anand@st.com>
> | Date:   Sat Jun 23 02:23:08 2012 +0530
> | 
> | usb: dwc3: remove WARN_ON from dwc_stop_active_transfer
> | 
> | Now we are sure that, if res_trans_idx is zero, then endpoint has been
> | stopped. So it's safe to just return if endpoint is already stopped. No
> | need to generate warning anymore.
> | 
> | While doing so, it's better to return when res_trans_idx is zero and
> | decrease one level of indentation.
> | 
> | Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> | 
> | [ balbi@ti.com: slightly changed commit log ]
> | 
> | Signed-off-by: Felipe Balbi <balbi@ti.com>
>
>> Tested-by : Shubhrajyoti <shubhrajyoti@ti.com>
> since you will send, you should, probably, add your Signed-off-by,
> instead of Tested-by. dunno.
>


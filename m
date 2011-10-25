Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab1JYNJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:09:50 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:50483 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933213Ab1JYNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:09:48 -0400
Message-ID: <4EA6B50F.40805@ti.com>
Date: Tue, 25 Oct 2011 18:39:35 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rajeev kumar <rajeev-dlh.kumar@st.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vikram Pandita <vikram.pandita@ti.com>
Subject: Re: [PATCH ] i2c: omap: recover from Bus Busy condition
References: <1319439118-3800-1-git-send-email-shubhrajyoti@ti.com> <4EA50F7F.6000400@st.com>
In-Reply-To: <4EA50F7F.6000400@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 October 2011 12:40 PM, Rajeev kumar wrote:
> On 10/24/2011 12:21 PM, Shubhrajyoti D wrote:
>> From: Vikram Pandita<vikram.pandita@ti.com>
>>
>>      In case a peripheral is holding the DATA bus low, provide a 400Khz
>>      constant clock output using the TEST register.
>>
>>      Also soft reset the I2C controller so that there is no stale state
>>      left in the HW state machine.
>>
>>      A WARN_ON() will be generated when a BB timeout happens.
>>
>> Signed-off-by: Vikram Pandita<vikram.pandita@ti.com>
>> Signed-off-by: Shubhrajyoti D<shubhrajyoti@ti.com>
>> ---
>>   drivers/i2c/busses/i2c-omap.c |   15 +++++++++++++--
>>   1 files changed, 13 insertions(+), 2 deletions(-)
>
>
> Reviewed-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>

Thanks for your review.
>
>
> ~Rajeev


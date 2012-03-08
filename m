Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab2CHQoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:44:00 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49377 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab2CHQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:43:55 -0500
Message-ID: <4F58E1C5.5090704@ti.com>
Date: Thu, 08 Mar 2012 22:13:49 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/8] OMAP4: hwmod: add EMIF hw mod data
References: <1331222065-3579-1-git-send-email-aneesh@ti.com> <1331222065-3579-2-git-send-email-aneesh@ti.com> <4F58E13C.8040906@ti.com>
In-Reply-To: <4F58E13C.8040906@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2012 10:11 PM, Cousson, Benoit wrote:
> Hi Aneesh
>
> On 3/8/2012 4:54 PM, Aneesh V wrote:
>> From: Benoit Cousson<b-cousson@ti.com>
>>
>> Add hwmod data for EMIF IP instances in OMAP4.
>
> Paul has just posted an OMAP4 hwmod series (ARM: OMAP4: hwmod data: add
> almost all remaining IP blocks) that does contain the EMIF hwmods, so
> assuming that you are not adding some custom dev_attr here, it should
> work for you.

Ok. I will test with that tomorrow and drop this patch.

Thanks,
Aneesh

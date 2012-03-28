Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2C1Bic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:38:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2550 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab2C1Bib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:38:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6662"; a="174099394"
Message-ID: <4F726B96.8070508@codeaurora.org>
Date: Tue, 27 Mar 2012 18:38:30 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <4F6BCF47.4090200@codeaurora.org> <20120326130005.GQ3098@opensource.wolfsonmicro.com>
In-Reply-To: <20120326130005.GQ3098@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2012 6:00 AM, Mark Brown wrote:
> On Thu, Mar 22, 2012 at 06:17:59PM -0700, Michael Bohan wrote:
>
>> I'm curious if there was a reason we didn't standardize on a binding
>> name for regulator supplies when using Device Tree. This appears to
>> cause duplicated code for regulator drivers that support devices
>> that may or may not have supplies specified.
>
> Supplies are *always* specified using the name from the part data sheet,
> anything to do with regulator-regulator supplies is a Linux
> implementation detail.

So before filling out the supply_name when calling regulator_register(), 
does that mean we should expect regulator drivers that optionally 
support supplies to always check with of_get_property()? And which name 
should we check? It sounds like the answer is that we should invent 
another binding to portray the name of the supply the driver should be 
checking against. But then it would seem silly to have two bindings that 
pertain to supply names.

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1HVJlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:41:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55362 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1HVJls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:41:48 -0400
Message-ID: <4E52244F.5030109@ti.com>
Date: Mon, 22 Aug 2011 10:41:35 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "dahuang@nvidia.com" <dahuang@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "mike@compulab.co.il" <mike@compulab.co.il>,
        "xxie@nvidia.com" <xxie@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting
References: <1312886870-17451-1-git-send-email-dahuang@nvidia.com> <20110822093518.GI4607@sortiz-mobl>
In-Reply-To: <20110822093518.GI4607@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/11 10:35, Samuel Ortiz wrote:
> Hi Xin,
> 
> On Tue, Aug 09, 2011 at 06:47:50PM +0800, dahuang@nvidia.com wrote:
>> From: Xin Xie <xxie@nvidia.com>
>>
>> Add output vlotage slew rate setting for SM0/SM1
>>
>> Signed-off-by: Xin Xie <xxie@nvidia.com>
>> Signed-off-by: Danny Huang <dahuang@nvidia.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Liam, are you taking this one ?
> 

I will do in the next few days. I've had an ADSL fault for the last two weeks that is keeping me off line atm. 

Liam

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0LaMz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 07:55:59 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47828 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0LaMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 07:55:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6212"; a="68833742"
Message-ID: <4D1DD2D7.30108@codeaurora.org>
Date: Fri, 31 Dec 2010 18:25:51 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
References: <kev@cypress.com> <1293650268-1561-1-git-send-email-kev@cypress.com> <20101231115323.GA9709@polaris.bitmath.org>
In-Reply-To: <20101231115323.GA9709@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 12/31/2010 5:23 PM, Henrik Rydberg wrote:
> Hi Kevin,
> 
> Thanks for the changes, it looks much better now. Some comments on the MT
> part inline.
> 
>> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
>> index 06ea8da..7d886bc 100644
>> --- a/drivers/input/touchscreen/Kconfig
>> +++ b/drivers/input/touchscreen/Kconfig
>> @@ -124,6 +124,11 @@ config TOUCHSCREEN_CY8CTMG110
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called cy8ctmg110_ts.
>>  
>> +config TOUCHSCREEN_CYTTSP_CORE
>> +	bool "Cypress TTSP touchscreen core"
>> +	help
>> +	  Always activated for Cypress TTSP touchscreen
>> +
> 
> Tristate please.

This code is just exporting APIs and doesn't need to be modular. No module_init/exit etc.,

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

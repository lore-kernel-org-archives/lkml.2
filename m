Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab0JFDhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:37:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30836 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab0JFDgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:36:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56754051"
Message-ID: <4CABEECC.6060703@codeaurora.org>
Date: Tue, 05 Oct 2010 20:36:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] [ARM] Allow machines to override __delay()
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>	<1285644827-6846-3-git-send-email-sboyd@codeaurora.org> <1286299778.18791.18.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1286299778.18791.18.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/05/2010 10:29 AM, Daniel Walker wrote:
>> diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
>> index 5ee0adc..b307fcc 100644
>> --- a/arch/arm/lib/delay.c
>> +++ b/arch/arm/lib/delay.c
>> @@ -3,6 +3,8 @@
>>   *
>>   *  Copyright (C) 1995, 1996 Russell King
>>   *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>> + *  Copyright (C) 1993 Linus Torvalds
>> + *  Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> Who is Martin Mares? Why are you adding these?

These are the respective copyrights from x86's delay.c for the code I
copied. I'll see if they can be dropped.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


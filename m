Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab0FURD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:03:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55404 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab0FURDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:03:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6020"; a="45070270"
Message-ID: <4C1F9B58.6020302@codeaurora.org>
Date: Mon, 21 Jun 2010 10:03:20 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Gregory Bean <gbean@codeaurora.org>, dwalker@codeaurora.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: Add gpio register address mapping information.
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org> <1276888375-13221-2-git-send-email-gbean@codeaurora.org> <20100619200249.GA2507@elf.ucw.cz>
In-Reply-To: <20100619200249.GA2507@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> --- /dev/null
>> +++ b/arch/arm/mach-msm/gpio_hw-7x30.h
>> @@ -0,0 +1,112 @@
>> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>> + *
>> + * Redistribution and use in source and binary forms, with or without
>> + * modification, are permitted provided that the following conditions are
>> + * met:
>> + *     * Redistributions of source code must retain the above copyright
>> + *       notice, this list of conditions and the following disclaimer.
>> + *     * Redistributions in binary form must reproduce the above
>> + *       copyright notice, this list of conditions and the following
>> + *       disclaimer in the documentation and/or other materials provided
>> + *       with the distribution.
>> + *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
>> + *       contributors may be used to endorse or promote products derived
>> + *       from this software without specific prior written permission.
> 
> Yeah. Either this can be replaced with GPL, and it such case just do
> so, or it can not, and then it can not be applied to kernel.
> 

This is a standard BSD-style license so it's compatible w/ the GPL.  Thanks.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

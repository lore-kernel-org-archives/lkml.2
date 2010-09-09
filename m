Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0IIDPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:15:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24949 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0IIDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:15:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6099"; a="53715449"
Message-ID: <4C885134.3070703@codeaurora.org>
Date: Wed, 08 Sep 2010 20:15:00 -0700
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/24] msm: MSM8X60 RUMI3 board support
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org> <1282712273-344-10-git-send-email-johlstei@codeaurora.org> <20100902110850.GV26319@n2100.arm.linux.org.uk>
In-Reply-To: <20100902110850.GV26319@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Tue, Aug 24, 2010 at 09:57:38PM -0700, Jeff Ohlstein wrote:
>   
>> +
>> +extern struct sys_timer msm_timer;
>> +void __iomem *gic_cpu_base_addr;
>>     
> Please move to a header file.
>   
I can move the extern to a header, not sure about the gic_cpu_base_addr. 
Seems like other machine types have it in C code. Even with a prototype 
in a header I need to define it somewhere.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


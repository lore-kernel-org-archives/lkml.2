Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0HJC0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 22:26:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23538 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0HJC0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 22:26:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6069"; a="50325223"
Message-ID: <4C60B8BB.2050209@codeaurora.org>
Date: Mon, 09 Aug 2010 20:26:03 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: khali@linux-fr.org, ben-linux@fluff.org, linux-arm-msm@vger.kernel.org,
        sdharia@codeaurora.org, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Single-wire Serial Bus Interface for Qualcomm MSM
 chipsets
References: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org> <20100728132607.GA16737@ucw.cz>
In-Reply-To: <20100728132607.GA16737@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> This bus driver supports the Single-wire Serial Bus Interface (SSBI)
>> controller in the Qualcomm MSM SOCs.  SSBI is not an I2C but is
>> functionally related enough such that it is able to leaverage the I2C
>> framework.
>>
>> Unlike I2C, SSBI is a point-to-point connection, and therefore there is no
>> need to specify a slave device address. The SSBI implementation
>> overrides the slave device address to be a device register address
> 
> Then perhaps it should not go to drivers/i2c? 
> 

I'd like to make use of the i2c framework rather than implement 
something else.  Are you suggesting that the driver reside elsewhere 
(i.e. mach-msm) or that the driver not use the i2c framework?

thanks.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

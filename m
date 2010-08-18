Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0HRTxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:53:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1432 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0HRTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:53:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51343978"
Message-ID: <4C6C3A28.8070108@codeaurora.org>
Date: Wed, 18 Aug 2010 12:53:12 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100809 Shredder/3.0.7pre
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/4] platform: Use drv->driver.bus instead of assuming
 platform_bus_type
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org> <1282158943-11902-2-git-send-email-ppannuto@codeaurora.org> <20100818194410.GA17421@suse.de>
In-Reply-To: <20100818194410.GA17421@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 12:44 PM, Greg KH wrote:
> On Wed, Aug 18, 2010 at 12:15:40PM -0700, Patrick Pannuto wrote:
>> In theory (although not *yet* in practice), a driver being passed
>> to platform_driver_probe might have driver.bus set to something
>> other than platform_bus_type. Locking drv->driver.bus is always
>> correct.
>>
>> Change-Id: Ib015c35237eb5493d17a812576a3a9906e1344d4
> 
> What is that field?  Why did you add it?
> 
> confused,
> 
> greg k-h

Ugh... It's from gerrit; forgot to remove them, sorry.

Do you want a fresh set, or can you just ignore them for now?

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

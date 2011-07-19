Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1GSKHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:07:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38146 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1GSKHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 06:07:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6411"; a="104371853"
Message-ID: <072dac57b14fc739033c65fe289234c3.squirrel@www.codeaurora.org>
In-Reply-To: <201107191118.48536.oneukum@suse.de>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
    <20110630174538.GA7979@xanatos>
    <8bcfda19cbc633e011e6b28a6183e68b.squirrel@www.codeaurora.org>
    <201107191118.48536.oneukum@suse.de>
Date: Tue, 19 Jul 2011 03:07:39 -0700 (PDT)
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to 
     devio.c
From: "Amit Blay" <ablay@codeaurora.org>
To: "Oliver Neukum" <oneukum@suse.de>
Cc: "Amit Blay" <ablay@codeaurora.org>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

>> 1. Interface number [IN]
>> 2. Bitmap indicating which EP to allocate streams for [IN]
>
> If this is a bitmap,
>
>> 3. Number of streams to allocate, one number [IN}
>> 4. Number of streams actually allocated, one number  [OUT]
>
> how can those be scalars?
>

The bitmap only indicates which EP the user space requests to allocate
streams for. The actual number is taken from #3.

Thanks,
Amit.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


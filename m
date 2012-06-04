Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2FDJvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:51:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2FDJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:51:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6731"; a="195046375"
Message-ID: <53f16b8f6198e1adb9cc54bb8b9d80cb.squirrel@www.codeaurora.org>
In-Reply-To: <4FCC280C.6030103@landley.net>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
    <4FCC280C.6030103@landley.net>
Date: Mon, 4 Jun 2012 02:51:49 -0700 (PDT)
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Rob Landley" <rob@landley.net>
Cc: "Sagar Dharia" <sdharia@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, kheitke@codeaurora.org, marc@plastictigers.com,
        gclemson@audience.com, broonie@opensource.wolfsonmicro.com,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, ohad@wizery.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Reply-To: sdharia@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Slim?
>
SLIMbus is MIPI alliance specification. Since word "bus" is part of the
specification, I thought it will be good to keep it that way.

The specification is available to all MIPI members.
Some more info here:
http://mipi.org/specifications/serial-low-power-inter-chip-media-bus-slimbussm-specification

>> +and the messages can be of unicast and broadcast type. E.g.
>> reading/writing
>> +device specific values is typically a unicast message. A data channel
>> +reconfiguration sequence is announced to all devices using a broadcast
>> message.
>
> Unicast messages are seen by all devices?
>
I was trying to give example of each type of both message. I will reword
it to be more clear.

>> +Slimbus specification has different types of device classifications
>> based on
>> +their capabilities.
>
> I'm trying to figure out if that sentence conveys any information at all.
>
I will reword this to say: "has following type of device classifications
based on capabilities:".

> So each slimbus has 1 manager device that enumerates configures, and
> allocates channels for the other devices on the bus. The rest are
> "framer" devices that transmit data packets?
>
Typically there is 1 framer per bus, but if there are multiple framers
then manager is responsible for doing handoff between framers.
>
> However, I expect some example code would be far more useful than this
> document...
>
Please refer to slimbus.c for slimbus framework.

Thank you for your comments. I will address all the comments in the next
patch.

Regards
Sagar

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


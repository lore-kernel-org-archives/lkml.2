Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1LEMKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:10:52 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19408 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1LEMKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:10:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6550"; a="141405834"
Message-ID: <9a0cf9e5dd108a8d17748c67afe45f9d.squirrel@www.codeaurora.org>
In-Reply-To: <20111205091109.GG9900@legolas.emea.dhcp.ti.com>
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
    <20111205082047.GA2423@linutronix.de>
    <20111205082326.GA2734@linutronix.de>
    <20111205083946.GE9900@legolas.emea.dhcp.ti.com>
    <4EDC86F1.2070301@linutronix.de>
    <20111205091109.GG9900@legolas.emea.dhcp.ti.com>
Date: Mon, 5 Dec 2011 04:10:50 -0800 (PST)
Subject: Re: [RFC] UASP on target
From: "Shimrit Malichi" <smalichi@codeaurora.org>
To: balbi@ti.com
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Shimrit Malichi" <smalichi@codeaurora.org>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>,
        "USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        target-devel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, Dec 05, 2011 at 09:55:13AM +0100, Sebastian Andrzej Siewior wrote:
>> On 12/05/2011 09:39 AM, Felipe Balbi wrote:
>> >Hi,
>> Hi,
>>
>> >On Mon, Dec 05, 2011 at 09:23:26AM +0100, Sebastian Andrzej Siewior
>> wrote:
>> >>* Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
>> >>
>> >>>* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
>> >>>
>> >>>>This patch implements the infrastructure for the UAS gadget driver.
>> >>>>The UAS gadget driver registers as a second configuration of the MS
>> >>>>gadet driver.
>> >>>hch said to use target framework and you haven't done so. This is
>> what I
>> >>>have so far. It is not yet complete. What I need to do is:
>> >>>- wire up command processing (currently here)
>> >>>- wire up data processing
>> >>>- check it works =>  post v1
>> >>>- wire up command tagging =>  v2
>> >>>- remove hard codings and fix whatever people complained about.
>> >
>> >This is much better, indeed, but the way it is now, it's only usable by
>> >the gadget framework because you have put the function driver on the
>> >transport layer. I wonder if there wouldn't be a simple way to split
>> the
>> >"SCSI Over USB" part in a more generic way which could be shared
>> between
>> >gadget side UASP and host side UASP drivers ?!? Maybe ?!?
>> >
>> >The drivers/target/uasp_*.c would really be just a transport layer and
>> >gadget/host drivers would make calls to that "library" ? Something like
>> >that ??
>>
>> There is very little code that is not host specific. For instance
>> uas_alloc_cmd_urb() is something that could be used on both side but
>> the host is boxing the command and I need to unbox it. So I don't see
>> how I could share things except for the defines.
>> Most of the things are usb specific. So UAS gets the commands from the
>> scsi framework, puts the usb layer around it and sends them.
>
> k, fair enough ;-) Just thought there'd be a better way to share this
> code with host side implementation. Nevermind then
>
> --
> balbi
>

Hi guys,

Thanks for your quick response.
We are glad to see that our initial implementation is being used and
gaining momentum.

We  intend to learn and re-implement the UAS protocol using the target
framework, and continue our work started few months ago.

We hope to get your corporation in the future as well.

Thanks,
Shimrit


-- 
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum



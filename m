Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1HQJuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:50:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38411 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1HQJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:50:16 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1108121147100.11936-100000@netrider.rowland.org>
References: <20110812092036.GM19467@legolas.emea.dhcp.ti.com>
	<Pine.LNX.4.44L0.1108121147100.11936-100000@netrider.rowland.org>
Date: Wed, 17 Aug 2011 11:50:15 +0200
Message-ID: <CAJ0pr19ErH1GpR2MbsGEM6vR54WfY4gT9OO9-+FQni6gkZp6Lg@mail.gmail.com>
Subject: Re: [PATCH v3] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
From: Per Forlin <per.forlin@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2011 17:49, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 12 Aug 2011, Felipe Balbi wrote:
>
>> On Mon, Aug 08, 2011 at 11:43:35PM +0200, Per Forlin wrote:
>> > FSG_NUM_BUFFERS is set to 2 as default.
>> > Usually 2 buffers are enough to establish a good buffering pipeline.
>> > The number may be increased in order to compensate a for bursty VFS
>> > behaviour.
>
>> would it make sense to have this as a module parameter so we don't need
>> to recompile the driver everytime we want to test the driver with a
>> different number of buffers ??
>>
>> Alan ?
>
> People generally object to new module parameters unless there's a very
> good reason for them.
>
> Since people won't want to experiment with changing this value unless
> they're debugging anyway, we might make it a conditional module
> parameter -- don't define the parameter unless CONFIG_USB_DEBUG is
> enabled.
>
I like this proposal. I'll send out a new version of this patch using
module_param instead of kconfig.

Thanks,
Per

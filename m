Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0F1RSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:18:40 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:63716 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296Ab0F1RSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:18:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4BAG12KExLd/sX/2dsb2JhbAAHgxaXDLVJkH6BKYMJcgQ
X-IronPort-AV: E=Sophos;i="4.53,498,1272859200"; 
   d="scan'208";a="69048967"
Message-ID: <4C28D96B.6060409@teksavvy.com>
Date: Mon, 28 Jun 2010 13:18:35 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: ps2mouse not working in 2.6.34
References: <4C28C81E.4010909@teksavvy.com> <20100628163350.GA11670@core.coreip.homeip.net>
In-Reply-To: <20100628163350.GA11670@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 12:33 PM, Dmitry Torokhov wrote:
> On Mon, Jun 28, 2010 at 12:04:46PM -0400, Mark Lord wrote:
>> Okay, who broke it, and how do I re-enable it?
>>
>> The PS/2 mice on my systems here don't do anything with 2.6.34.
>> One system complains that I need to boot with i8042.nopnp to enable it,
>> which I also tried, but still nogo.  Same behaviour with or without
>> /dev/psaux enabled.  64-bit kernel.
>>
>> The other system, running older userspace, hangs at the X-server startup
>> because it cannot find the mouse.  No i8042 warnings.   32-bit kernel.
>>
>> Both systems working fine with older kernels.
>> Google finds lots of other people discovering the same problem.
>>
>> What gives?
>>
>
> Well, lest start small: did it work ifor you with 2.6.33? Does kernel
> discover AUX serio port (dmesg)? What about the mouse itself? Is it
> absent or is it not reporting events?
..

I started by crawling into the wire nest under the table.  :)

After a certain amount of experimentation, it appears that the newer
kernel is not compatible with the USB-to-PS2 dongle on the end of the mouse.
I found a different USB-to-PS2 dongle which does work, though.

Very weird.  I can mail you the other dongle if are really interested
in figuring out what broke and fixing it.

Otherwise, things are now working here again after the hardware change.

Cheers

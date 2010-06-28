Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab0F1U6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:58:04 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:24807 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751470Ab0F1U6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:58:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMBAP2pKExLd/sX/2dsb2JhbAAHgxaXErVqkS6BKYMJcgSGZQ
X-IronPort-AV: E=Sophos;i="4.53,499,1272859200"; 
   d="scan'208";a="69071381"
Message-ID: <4C290CD7.5030200@teksavvy.com>
Date: Mon, 28 Jun 2010 16:57:59 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: ps2mouse not working in 2.6.34
References: <4C28C81E.4010909@teksavvy.com> <20100628163350.GA11670@core.coreip.homeip.net> <4C28D96B.6060409@teksavvy.com> <201006281031.32568.dmitry.torokhov@gmail.com>
In-Reply-To: <201006281031.32568.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 01:31 PM, Dmitry Torokhov wrote:
> On Monday, June 28, 2010 10:18:35 am Mark Lord wrote:
>> On 28/06/10 12:33 PM, Dmitry Torokhov wrote:
>>> On Mon, Jun 28, 2010 at 12:04:46PM -0400, Mark Lord wrote:
>>>> Okay, who broke it, and how do I re-enable it?
>>>>
>>>> The PS/2 mice on my systems here don't do anything with 2.6.34.
>>>> One system complains that I need to boot with i8042.nopnp to enable it,
>>>> which I also tried, but still nogo.  Same behaviour with or without
>>>> /dev/psaux enabled.  64-bit kernel.
>>>>
>>>> The other system, running older userspace, hangs at the X-server startup
>>>> because it cannot find the mouse.  No i8042 warnings.   32-bit kernel.
>>>>
>>>> Both systems working fine with older kernels.
>>>> Google finds lots of other people discovering the same problem.
>>>>
>>>> What gives?
>>>
>>> Well, lest start small: did it work ifor you with 2.6.33? Does kernel
>>> discover AUX serio port (dmesg)? What about the mouse itself? Is it
>>> absent or is it not reporting events?
>>
>> ..
>>
>> I started by crawling into the wire nest under the table.  :)
>>
>> After a certain amount of experimentation, it appears that the newer
>> kernel is not compatible with the USB-to-PS2 dongle on the end of the
>> mouse. I found a different USB-to-PS2 dongle which does work, though.
>>
>> Very weird.  I can mail you the other dongle if are really interested
>> in figuring out what broke and fixing it.
>
> Hmm, let me dig out one of my dongles first and see if it is broken too... If
> not I might be interested in getting yours but no promises - time is tight ;(
..

I'm beginning to suspect the dongle I was using simply went bad
at the same time I upgraded kernels.  It no longer works with older stuff either.

So.. unfortunate timing of a hardware failure with kernel upgrade.

Nothing to see here.

Thanks Dmitry!


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0F1Qee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:34:34 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:64538 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259Ab0F1Qeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:34:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4BANdrKExLd/sX/2dsb2JhbAAHgxaXDLVlkG+BKYMJcgQ
X-IronPort-AV: E=Sophos;i="4.53,498,1272859200"; 
   d="scan'208";a="69044639"
Message-ID: <4C28CF16.30904@teksavvy.com>
Date: Mon, 28 Jun 2010 12:34:30 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: ps2mouse not working in 2.6.34
References: <4C28C81E.4010909@teksavvy.com>
In-Reply-To: <4C28C81E.4010909@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 12:04 PM, Mark Lord wrote:
> Okay, who broke it, and how do I re-enable it?
>
> The PS/2 mice on my systems here don't do anything with 2.6.34.
> One system complains that I need to boot with i8042.nopnp to enable it,
> which I also tried, but still nogo. Same behaviour with or without
> /dev/psaux enabled. 64-bit kernel.
>
> The other system, running older userspace, hangs at the X-server startup
> because it cannot find the mouse. No i8042 warnings. 32-bit kernel.
>
> Both systems working fine with older kernels.
> Google finds lots of other people discovering the same problem.
>
> What gives?
..

Mmmm.. the problem started for some people with 2.6.32:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/587134

That thread has a suggestion that perhaps
    "the kernel fails to properly set the power settings for the PS2 port"

Whatever that means.  :)

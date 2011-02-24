Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1BXTXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:23:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52097 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab1BXTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:23:34 -0500
Message-ID: <4D66AFDB.5010005@ru.mvista.com>
Date: Thu, 24 Feb 2011 22:22:03 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Takashi Iwai <tiwai@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] xhci: Fix cycle bit calculation during stall handling.
References: <cover.1298514502.git.sarah.a.sharp@linux.intel.com> <e1b54e2b29b06b62174de33a74fa7469173abc92.1298514502.git.sarah.a.sharp@linux.intel.com> <4D663E80.8050906@ru.mvista.com> <20110224153855.GA25590@xanatos>
In-Reply-To: <20110224153855.GA25590@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Sarah Sharp wrote:

>>> +	if (ep_ring->first_seg == ep_ring->first_seg->next&&
>>> +			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
>>> +			state->new_cycle_state ^= 0x1;

>>    The last line seems overindented.

> Hi Sergei,

> checkpatch.pl doesn't complain about it.  It is not a good use of my
> time to respin this patch for one stylistic change that is not a
> violation of the Kernel community norms.

> I really feel strongly that you are wasting the community's time by
> commenting on style when it is only a violation of your personal style,
> without providing any useful feedback on the code itself.

    Not only of my personal style, as Dmitry's comment has shown. Like him, I 
had some trouble seeing where the *if* expression ends and the branch starts, 
due to both lines starting on the same level of indentation...

> I feel so strongly that I'm seriously considering setting up a feedback
> bot for you.  It would run any patch you reply to through checkpatch.pl,
> and send you a small reminder when the patch passes, but you complained
> about style.  I think it would allow you to have a sense of how
> frustrating it is to receive these unnecessary stylistic comments.

    Well, I'll try to save you that trouble and avoid commenting on your patches 
in the future.

> Sarah Sharp

WBR, Sergei

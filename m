Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1BXPjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:39:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:34893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1BXPjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:39:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,218,1297065600"; 
   d="scan'208";a="890879804"
Date: Thu, 24 Feb 2011 07:38:55 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] xhci: Fix cycle bit calculation during stall
 handling.
Message-ID: <20110224153855.GA25590@xanatos>
References: <cover.1298514502.git.sarah.a.sharp@linux.intel.com>
 <e1b54e2b29b06b62174de33a74fa7469173abc92.1298514502.git.sarah.a.sharp@linux.intel.com>
 <4D663E80.8050906@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D663E80.8050906@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 02:18:24PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 24-02-2011 5:31, Sarah Sharp wrote:
> 
> >+	if (ep_ring->first_seg == ep_ring->first_seg->next&&
> >+			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
> >+			state->new_cycle_state ^= 0x1;
> 
>    The last line seems overindented.

Hi Sergei,

checkpatch.pl doesn't complain about it.  It is not a good use of my
time to respin this patch for one stylistic change that is not a
violation of the Kernel community norms.

I really feel strongly that you are wasting the community's time by
commenting on style when it is only a violation of your personal style,
without providing any useful feedback on the code itself.

I feel so strongly that I'm seriously considering setting up a feedback
bot for you.  It would run any patch you reply to through checkpatch.pl,
and send you a small reminder when the patch passes, but you complained
about style.  I think it would allow you to have a sense of how
frustrating it is to receive these unnecessary stylistic comments.

Sarah Sharp

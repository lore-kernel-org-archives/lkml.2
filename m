Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1BXRMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:12:46 -0500
Received: from kroah.org ([198.145.64.141]:47060 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab1BXRMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:12:43 -0500
Date: Thu, 24 Feb 2011 09:04:10 -0800
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Takashi Iwai <tiwai@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] xhci: Fix cycle bit calculation during stall handling.
Message-ID: <20110224170410.GB7841@kroah.com>
References: <cover.1298514502.git.sarah.a.sharp@linux.intel.com>
 <e1b54e2b29b06b62174de33a74fa7469173abc92.1298514502.git.sarah.a.sharp@linux.intel.com>
 <4D663E80.8050906@ru.mvista.com>
 <20110224153855.GA25590@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224153855.GA25590@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 07:38:55AM -0800, Sarah Sharp wrote:
> On Thu, Feb 24, 2011 at 02:18:24PM +0300, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 24-02-2011 5:31, Sarah Sharp wrote:
> > 
> > >+	if (ep_ring->first_seg == ep_ring->first_seg->next&&
> > >+			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
> > >+			state->new_cycle_state ^= 0x1;
> > 
> >    The last line seems overindented.
> 
> Hi Sergei,
> 
> checkpatch.pl doesn't complain about it.  It is not a good use of my
> time to respin this patch for one stylistic change that is not a
> violation of the Kernel community norms.
> 
> I really feel strongly that you are wasting the community's time by
> commenting on style when it is only a violation of your personal style,
> without providing any useful feedback on the code itself.
> 
> I feel so strongly that I'm seriously considering setting up a feedback
> bot for you.  It would run any patch you reply to through checkpatch.pl,
> and send you a small reminder when the patch passes, but you complained
> about style.  I think it would allow you to have a sense of how
> frustrating it is to receive these unnecessary stylistic comments.

I totally agree, and almost always just filter Sergei's comments away as
the large majority of them are pointless and distract from the technical
content being discussed.

Sergei, you have been warned of this before, please change in the
future.

thanks,

greg k-h

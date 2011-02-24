Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1BXSgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:36:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42182 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab1BXSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:36:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vkpn06HHFqatYYmIMZ4P+/qJLIKraqO+6rSRaQaW2JXUPlvHMVJJQJ0rZHd4BZLD/2
         Ej/O2YWQF7jeTRNuR94G/04RUitOl3JuzkUZfLK6CGYQZY3KXcDndraxEgzDnPHvyOML
         jagQ/gighWUAiHPJI/Pt7WlEZkcPJAjZXyZv0=
Date: Thu, 24 Feb 2011 10:35:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Takashi Iwai <tiwai@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] xhci: Fix cycle bit calculation during stall handling.
Message-ID: <20110224183555.GA2283@core.coreip.homeip.net>
References: <cover.1298514502.git.sarah.a.sharp@linux.intel.com>
 <e1b54e2b29b06b62174de33a74fa7469173abc92.1298514502.git.sarah.a.sharp@linux.intel.com>
 <4D663E80.8050906@ru.mvista.com>
 <20110224153855.GA25590@xanatos>
 <20110224170410.GB7841@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224170410.GB7841@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:04:10AM -0800, Greg KH wrote:
> On Thu, Feb 24, 2011 at 07:38:55AM -0800, Sarah Sharp wrote:
> > On Thu, Feb 24, 2011 at 02:18:24PM +0300, Sergei Shtylyov wrote:
> > > Hello.
> > > 
> > > On 24-02-2011 5:31, Sarah Sharp wrote:
> > > 
> > > >+	if (ep_ring->first_seg == ep_ring->first_seg->next&&
> > > >+			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
> > > >+			state->new_cycle_state ^= 0x1;
> > > 
> > >    The last line seems overindented.
> > 
> > Hi Sergei,
> > 
> > checkpatch.pl doesn't complain about it.  It is not a good use of my
> > time to respin this patch for one stylistic change that is not a
> > violation of the Kernel community norms.
> > 
> > I really feel strongly that you are wasting the community's time by
> > commenting on style when it is only a violation of your personal style,
> > without providing any useful feedback on the code itself.
> > 
> > I feel so strongly that I'm seriously considering setting up a feedback
> > bot for you.  It would run any patch you reply to through checkpatch.pl,
> > and send you a small reminder when the patch passes, but you complained
> > about style.  I think it would allow you to have a sense of how
> > frustrating it is to receive these unnecessary stylistic comments.
> 
> I totally agree, and almost always just filter Sergei's comments away as
> the large majority of them are pointless and distract from the technical
> content being discussed.
> 

I am sorry, but in this case the 'if' body does run together with the
conditional. No need to repost the patch for this, of course, but might
be worth fixing locally before pushing into a public branch.

Thanks.

-- 
Dmitry

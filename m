Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab0FGV1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:27:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35434 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab0FGV1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:27:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [TuxOnIce-devel] [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm for reading & writing a hibernation image.
Date: Mon, 7 Jun 2010 23:28:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: tuxonice-devel@tuxonice.net, Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <4C0C843D.6030008@crca.org.au> <201006071507.56259.Martin@lichtvoll.de>
In-Reply-To: <201006071507.56259.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006072328.21878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 June 2010, Martin Steigerwald wrote:
> Am Montag 07 Juni 2010 schrieb Nigel Cunningham:
> > Hi.
> 
> Hi Nigel and Rafael, hi everyone else involved,
> 
> > On 07/06/10 05:04, Rafael J. Wysocki wrote:
> > > On Sunday 06 June 2010, Maxim Levitsky wrote:
> > >> On Sun, 2010-06-06 at 15:57 +0200, Rafael J. Wysocki wrote:
> > >>> On Sunday 06 June 2010, Maxim Levitsky wrote:
> > > ...
> > > 
> > >>> So how TuxOnIce helps here?
> > >> 
> > >> Very simple.
> > >> 
> > >> With swsusp, I can save 750MB (memory) + 250 Vram (vram)
> > >> With full memory save I can save (1750 MB of memory) + 250 MB of
> > >> vram....
> > > 
> > > So what about being able to save 1600 MB total instead of the 2 GB
> > > (which is what we're talking about in case that's not clear)?  Would
> > > it be _that_ _much_ worse?
> > 
> > That all depends on what is in the 400MB you discard.
> > 
> > The difference is "Just as if you'd never hibernated" vs something
> > closer to "Just as if you'd only just started up". We can't make
> > categorical statements because it really does depend upon what you
> > discard and what you want to do post-resume - that is, how useful the
> > memory you discard would have been. That's always going to vary from
> > case to case.
> 
> Nigel and Rafael, how about just testing it?

ISTR that can be done to some extent using TuxOnIce as is, becuase there is a
knob that you can use to limit the image size.
 
> Whats needed to have 80% of the memory saved instead of 50%?
>
> I think its important to go the next steps towards a better snapshot in 
> mainline kernel even when you do not agree on the complete end result yet.
> 
> What about
> 
> - Rafael, you review the async write patches of Nigel. If they are good, 
> IMHO they should go in as soon as possible.

Yes, I'm going to do that.

> - Nigel and/or Rafael, you look at whats needed to save 80% instead of 50% 
> of the memory and develop a patch for it

That would be my suggestion as well.

Thanks,
Rafael

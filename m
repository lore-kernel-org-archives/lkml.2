Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab0I3As2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:48:28 -0400
Received: from kroah.org ([198.145.64.141]:49635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0I3As1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:48:27 -0400
Date: Wed, 29 Sep 2010 17:06:44 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kyle McMartin <kyle@redhat.com>, stable@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Dingwall <james.dingwall@amdocs.com>
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
	after the boot
Message-ID: <20100930000644.GA26380@kroah.com>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com> <20100927024044.GQ13116@bombadil.infradead.org> <20100927061336.GA22721@kroah.com> <4CA0DDAB.9090507@goop.org> <20100928182910.GA32464@kroah.com> <4CA35FB7.10600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA35FB7.10600@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 08:48:07AM -0700, Jeremy Fitzhardinge wrote:
>  On 09/28/2010 11:29 AM, Greg KH wrote:
> > On Mon, Sep 27, 2010 at 11:08:43AM -0700, Jeremy Fitzhardinge wrote:
> >>  On 09/26/2010 11:13 PM, Greg KH wrote:
> >>> On Sun, Sep 26, 2010 at 10:40:44PM -0400, Kyle McMartin wrote:
> >>>> On Thu, Sep 23, 2010 at 04:23:55PM +0100, James Dingwall wrote:
> >>>>>> I was experiencing the same immediate crash with a null pointer
> >>>>>> dereference (log below) on boot with 2.6.35.5.  Reverting
> >>>>>> fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
> >>>>>> me.
> >>>>> Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.
> >>>>>
> >>>> Greg, a spelling mistake cropped into this patch during 2.6.35.5 that
> >>>> James here points out. Adding you to CC since it seems to have missed
> >>>> stable 2.6.35.6...
> >>>>
> >>>> Was in xen-use-percpu-interrupts-for-ipis-and-virqs.patch.
> >>> I don't understand, where did the error come from?  Was it in a patch I
> >>> applied, or did I mess up some patch?  Is the same problem upstream, and
> >>> if not, why not?
> >> I don't know.  It looks like an 'x' was deleted due to an editor
> >> fat-finger or something.  The original upstream patches were cc:d to
> >> stable, so I think you would have got them that way (ie, I don't think I
> >> sent them to you specifically).  Is there an opportunity in your
> >> workflow where this error could have crept in?  The patches should have
> >> been a pretty clean 'git cherry-pick' with no conflicts.
> > Sorry, I don't know what happened, using my scripts, it does drop to an
> > editor so I can add the "signed-off-by" line, so perhaps I accidentally
> > did this in there.
> >
> > It's now in the -stable queue and I'll push out new releases in a few
> > hours.
> >
> 
> I should have pointed out it is the same in the stable-2.6.32 tree as well.

Yes, sorry, I know, I only had the chance to get the .35 release out
yesterday, I'll do the .32 one now.

thanks,

greg k-h

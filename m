Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0I0GNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:13:52 -0400
Received: from kroah.org ([198.145.64.141]:37494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab0I0GNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:13:51 -0400
Date: Sun, 26 Sep 2010 23:13:36 -0700
From: Greg KH <greg@kroah.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: James Dingwall <james.dingwall@amdocs.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
	after the boot
Message-ID: <20100927061336.GA22721@kroah.com>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com> <20100927024044.GQ13116@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927024044.GQ13116@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 10:40:44PM -0400, Kyle McMartin wrote:
> On Thu, Sep 23, 2010 at 04:23:55PM +0100, James Dingwall wrote:
> > > I was experiencing the same immediate crash with a null pointer
> > > dereference (log below) on boot with 2.6.35.5.  Reverting
> > > fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
> > > me.
> > 
> > Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.
> > 
> 
> Greg, a spelling mistake cropped into this patch during 2.6.35.5 that
> James here points out. Adding you to CC since it seems to have missed
> stable 2.6.35.6...
> 
> Was in xen-use-percpu-interrupts-for-ipis-and-virqs.patch.

I don't understand, where did the error come from?  Was it in a patch I
applied, or did I mess up some patch?  Is the same problem upstream, and
if not, why not?

And finally, can you send this in a format that I can apply it?

thanks,

greg k-h

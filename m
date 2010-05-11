Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0EKPMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab0EKPM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:28 -0400
Date: Tue, 11 May 2010 08:04:29 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [003/117] drm/i915: Add initial bits for VGA modesetting
 bringup on Sandybridge.
Message-ID: <20100511150429.GC14895@suse.de>
References: <20100510223317.484832756@kvm.kroah.org>
 <87hbmfm9wn.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbmfm9wn.fsf@pollan.anholt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 07:47:52PM -0700, Eric Anholt wrote:
> On Mon, 10 May 2010 15:31:34 -0700, Greg KH <gregkh@suse.de> wrote:
> > 2.6.33-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Eric Anholt <eric@anholt.net>
> > 
> > commit bad720ff3e8e47a04bd88d9bbc8317e7d7e049d3 upstream.
> > 
> > [needed for stable as it's just a bunch of macros that other drm patches
> > need, it changes no code functionality besides adding support for a new
> > device type. - gregkh]
> > 
> > Signed-off-by: Eric Anholt <eric@anholt.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This patch should not go in stable because of this hunk:
> 
> > --- a/include/drm/drm_pciids.h
> > +++ b/include/drm/drm_pciids.h
> > @@ -560,4 +560,5 @@
> >  	{0x8086, 0x35e8, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
> >  	{0x8086, 0x0042, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
> >  	{0x8086, 0x0046, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
> > +	{0x8086, 0x0102, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
> >  	{0, 0, 0}
> 
> Without that, it would be fine.

Ok, thanks, I've dropped this hunk from the patch now.

greg k-h

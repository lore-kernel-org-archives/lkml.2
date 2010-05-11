Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0EKPMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0EKPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:48 -0400
Date: Tue, 11 May 2010 08:10:49 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@canonical.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [107/117] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100511151049.GH14895@suse.de>
References: <20100510223700.GA18404@kroah.com>
 <20100510223327.043329892@kvm.kroah.org>
 <20100511033825.GA7513@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511033825.GA7513@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 09:38:25PM -0600, Alex Chiang wrote:
> Hm, this patch looks a little wonky.
> 
> Why is every entry repeated 3x?
> 
> > +	.callback = init_set_sci_en_on_resume,
> > +	.ident = "Lenovo ThinkPad T410",
> 
> [snip]
> 
> > +	.callback = init_set_sci_en_on_resume,
> > +	.ident = "Lenovo ThinkPad T410",
> 
> [snip[
> 
> > +	.callback = init_set_sci_en_on_resume,
> > +	.ident = "Lenovo ThinkPad T410",
> 
> Oh crap, it's broken upstream too. :(
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=patch;h=07bedca29b0973f36a6b6db36936deed367164ed
> 
> Not sure what happened, but I think some sort of hiccup occurred
> when the patch was applied, since this is what hit the mailing
> lists:
> 
> https://patchwork.kernel.org/patch/94711/
> 
> Len, Greg, what would you like me to do? I think the cleanest
> thing to do to help keep -stable clean would be to:
> 
> 	a) drop this patch from current -stable queue
> 	b) revert 07bedca29b09 upstream
> 	c) apply the patch from patchwork
> 	d) re-apply to -stable
> 
> Thoughts?

How about getting a fixup patch into Linus's tree and then I'll apply
that fixup patch to stable as well?

In the meantime, triplicates don't hurt anyone :)

thanks,

greg k-h

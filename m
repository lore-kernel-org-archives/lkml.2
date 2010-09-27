Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab0I0Gem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0I0Gel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:34:41 -0400
Date: Mon, 27 Sep 2010 02:34:05 -0400
From: Kyle McMartin <kmcmartin@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: James Dingwall <james.dingwall@amdocs.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after
 the boot
Message-ID: <20100927063405.GM19458@ihatethathostname.lab.bos.redhat.com>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
 <20100927024044.GQ13116@bombadil.infradead.org>
 <20100927061336.GA22721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927061336.GA22721@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 11:13:36PM -0700, Greg KH wrote:
> > Greg, a spelling mistake cropped into this patch during 2.6.35.5 that
> > James here points out. Adding you to CC since it seems to have missed
> > stable 2.6.35.6...
> > 
> > Was in xen-use-percpu-interrupts-for-ipis-and-virqs.patch.
> 
> I don't understand, where did the error come from?  Was it in a patch I
> applied, or did I mess up some patch?  Is the same problem upstream, and
> if not, why not?

It's correct upstream, and wrong in the patches you added to
stable-queue.git for .32 and .35, no idea how it got introduced. :/

> 
> And finally, can you send this in a format that I can apply it?
> 

I'm just the messenger... James, can you send a patch to Greg with your
signed-off-by and such?

--Kyle

> thanks,
> 
> greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab1GRPBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:01:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58816
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab1GRPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:01:44 -0400
Date: Mon, 18 Jul 2011 11:01:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Barkalow <barkalow@iabervon.org>,
        Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
Message-ID: <20110718150141.GA28123@infradead.org>
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org>
 <20110714135302.GA28501@thinkpad-t410>
 <alpine.LNX.2.00.1107141330370.2056@iabervon.org>
 <alpine.LNX.2.00.1107142116260.2056@iabervon.org>
 <20110715143900.GB19063@thinkpad-t410>
 <20110718133651.GA19552@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718133651.GA19552@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 08:36:51AM -0500, Seth Forshee wrote:
> On Fri, Jul 15, 2011 at 09:39:00AM -0500, Seth Forshee wrote:
> > What I also see are GPFs in memory allocation code, which is what I
> > believe others have seen with my patch, and so far I haven't seen those
> > with the reversions. So I'm suspecting memory corruption, but I don't
> > yet see where the corruption is coming form. I found one problem, but I
> > don't suspect it's responsible for the GPFs.
> 
> I had some torture tests running over the weekend with the "one
> problem" mentioned above fixed, which was a couple of kfrees that were
> still using the old vhdr pointers. There were no oopses over a couple of
> days of testing. I've posted a new build on the bug in launchpad in
> hopes of getting some testing from those who were getting oopses quite
> readily. The updated patch follows.

Thanks a lot Seth.  I'll put it into my queue for Linux 3.1, and if
everthing works out fine we can push it out to -stable.


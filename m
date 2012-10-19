Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2JSTTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:19:49 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:51834 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab2JSTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:19:48 -0400
Date: Fri, 19 Oct 2012 20:19:44 +0100
From: Richard Davies <richard.davies@elastichosts.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Dmitry Fleytman <dmitry@daynix.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>
Subject: Re: [E1000-devel] [PATCH] RX initialization sequence fixed -
 enable RX after corresponding ring initialization only
Message-ID: <20121019191944.GA27699@alpha.arachsys.com>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
 <1350235151-11146-2-git-send-email-dmitry@daynix.com>
 <1350280341.2152.12.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350280341.2152.12.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> Dmitry Fleytman wrote:
> > Reported-by: Chris Webb <chris.webb@elastichosts.com>
> > Reported-by: Richard Davies <richard.davies@elastichosts.com>
> >
> > Signed-off-by: Dmitry Fleytman <dmitry@daynix.com>
> > ---
> >  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
> >  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18
> > ++++++++++++++++--
> >  2 files changed, 21 insertions(+), 6 deletions(-) 
>
> I will add it to my queue.  Thanks!

Hi Jeff,

I hope it was already clear from the following discussion - this patch
turned out to be a qemu-kvm bug and you do not need to apply it.

Dmitry - please confirm.

Richard.

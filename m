Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab2FHCPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:15:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47858 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759939Ab2FHCPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:15:45 -0400
X-Sasl-enc: NN46Oss0x3kDp+6F1/D4plxFIdUBOm5arnpLZVLCFdDv 1339121744
Date: Fri, 8 Jun 2012 11:15:42 +0900
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: jeffrey.t.kirsher@intel.com, tarbal@gmail.com, rkagan@parallels.com,
        stable@vger.kernel.org, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, dnelson@redhat.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000: save skb counts in TX to avoid cache misses
Message-ID: <20120608021542.GA10112@kroah.com>
References: <b838d871c0d507787373061e4edd91a624d62475.1339073391.git.rkagan@parallels.com>
 <4FD11F49.5060805@gmail.com>
 <20120607.144358.1732928576389957779.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607.144358.1732928576389957779.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 02:43:58PM -0700, David Miller wrote:
> From: Jeff Kirsher <tarbal@gmail.com>
> Date: Thu, 07 Jun 2012 14:38:17 -0700
> 
> > Thanks! I have applied the patch to my queue
> 
> Why?
> 
> My impression is that this is a patch already in the tree, and it's
> being submitted for -stable but such minor performance hacks are
> absolutely not appropriate for -stable submission.

The patch description says it is fixing reported oopses, but the
Subject: isn't all that helpful there.

So which is this?  Should I accept it for a stable release or not?

thanks,

greg k-h

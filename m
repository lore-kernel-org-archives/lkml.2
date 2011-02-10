Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1BJVZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:25:46 -0500
Received: from kroah.org ([198.145.64.141]:60557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1BJVZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:25:45 -0500
Date: Thu, 10 Feb 2011 13:20:30 -0800
From: Greg KH <greg@kroah.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the tty tree with the m68knommu
 tree
Message-ID: <20110210212030.GA19226@kroah.com>
References: <20110210162914.eec2f4b5.sfr@canb.auug.org.au>
 <20110210185115.GB15944@kroah.com>
 <4D5452E5.9080304@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5452E5.9080304@snapgear.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 07:04:37AM +1000, Greg Ungerer wrote:
> On 11/02/11 04:51, Greg KH wrote:
> >On Thu, Feb 10, 2011 at 04:29:14PM +1100, Stephen Rothwell wrote:
> >>Hi Greg,
> >>
> >>Today's linux-next merge of the tty tree got a conflict in
> >>drivers/tty/serial/68328serial.c between commit
> >>abf67e214f867d16df6a9c4ac7d8fc0b98ebad97 ("m68knommu: fix derefernce of
> >>port.tty") from the m68knommu tree and commit
> >>f094298bae5f5d0e1cb3bff4621aae7ef486812a ("68328serial: remove unsed
> >>m68k_serial->tqueue_hangup") from the tty tree.
> >>
> >>I just used the latter since it removed some of the code modified by the
> >>former.
> >
> >Sounds fine, thanks.
> 
> The fix in commit abf67e214f867d16df6a9c4ac7d8fc0b98ebad97 ("m68knommu:
> fix derefernce of port.tty") are needed to get that file to compile.
> So I will be sending that to Linus for 2.6.38 (ie very soon).

That's fine with me, thanks for doing that.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0LFWxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:53:13 -0500
Received: from kroah.org ([198.145.64.141]:52365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0LFWxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:53:12 -0500
Date: Mon, 6 Dec 2010 14:46:22 -0800
From: Greg KH <greg@kroah.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [stable] [BUGFIX] memcg: avoid deadlock between move charge
 and try_charge()
Message-ID: <20101206224622.GN9265@kroah.com>
References: <20101116191748.d6645376.nishimura@mxp.nes.nec.co.jp>
 <20101116124117.64608b66.akpm@linux-foundation.org>
 <20101117092401.61c2117a.nishimura@mxp.nes.nec.co.jp>
 <20101126164825.24e684ca.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126164825.24e684ca.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 04:48:25PM +0900, Daisuke Nishimura wrote:
> > > > Cc: <stable@kernel.org>
> > > 
> > > The patch doesn't apply well to 2.6.36 so if we do want it backported
> > > then please prepare a tested backport for the -stable guys?
> > > 
> > O.K.
> > I'll test a backported patch for 2.6.36.y and send it after this is merged into mainline.
> > 
> Done.
> 
> I've tested this backported patch on 2.6.36 and it works properly.
> There is no change in mm/memcontrol.c from v2.6.36 to v2.6.36.1, so
> this can be applied to 2.6.36.1 too.

Thanks for the patch, I've now queued it up for .36-stable.

greg k-h

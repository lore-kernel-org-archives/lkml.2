Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2BNWnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:43:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35099 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757295Ab2BNWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:43:50 -0500
X-Sasl-enc: rPVt8WyzOFYRQT/QSTVTowuiMvP8sspt4i9oPmG5HbM9 1329259423
Date: Tue, 14 Feb 2012 14:37:58 -0800
From: Greg KH <greg@kroah.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?V=EDctor_Manuel_J=E1quez?= <vjaquez@igalia.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20120214223758.GA21350@kroah.com>
References: <20120210154806.4a81ec53dc24a40cf91a758a@canb.auug.org.au>
 <20120210053036.GC2068@kroah.com>
 <CAB-zwWggC696WKszdkFvE+7azu5LtuVK8__SUcjBX3UP4ieV-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-zwWggC696WKszdkFvE+7azu5LtuVK8__SUcjBX3UP4ieV-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 03:31:39PM -0600, Ramirez Luna, Omar wrote:
> Hi,
> 
> On Thu, Feb 9, 2012 at 11:30 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Feb 10, 2012 at 03:48:06PM +1100, Stephen Rothwell wrote:
> >> Hi Greg,
> >>
> >> Today's linux-next merge of the staging tree got a conflict in
> >> drivers/staging/tidspbridge/rmgr/drv_interface.c between commit
> >> 5a63177a6967 ("staging: tidspbridge: fix bridge_open memory leaks") from
> >> Linus' tree and commit 518761dba127 ("staging: tidspbridge: remove unused
> >> header") from the staging tree.
> >>
> >> I fixed it up (I think - see below) and can carry the fix as necessary.
> >
> > Thanks, I'll try to fix this up with a merge tomorrow to get this in
> > sync.
> 
> 5a63177a6967 ("staging: tidspbridge: fix bridge_open memory leaks")
> was accidentally reverted with the merge of staging-3.3-rc3 on
> staging-next branch, the same patch still applies since the previous
> patch touching this code moves it some lines above.

Ok, so what should I do here?  What patch should I apply to the
staging-next tree?  Just reapply 5a63177a6967?

confused,

greg k-h

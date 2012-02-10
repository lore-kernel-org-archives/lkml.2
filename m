Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2BJFe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:34:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56981 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab2BJFe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:34:27 -0500
X-Sasl-enc: BVv+cHFVcLAmW1TwZtCoh6PFn4W5+YdWBUkvrME+B6uJ 1328852065
Date: Thu, 9 Feb 2012 21:30:36 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        =?iso-8859-1?Q?V=EDctor_Manuel_J=E1quez?= Leal 
	<vjaquez@igalia.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20120210053036.GC2068@kroah.com>
References: <20120210154806.4a81ec53dc24a40cf91a758a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210154806.4a81ec53dc24a40cf91a758a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 03:48:06PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/tidspbridge/rmgr/drv_interface.c between commit
> 5a63177a6967 ("staging: tidspbridge: fix bridge_open memory leaks") from
> Linus' tree and commit 518761dba127 ("staging: tidspbridge: remove unused
> header") from the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks, I'll try to fix this up with a merge tomorrow to get this in
sync.

greg k-h

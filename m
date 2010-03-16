Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab0CPH40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:56:26 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54564 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab0CPH4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:56:24 -0400
Date: Tue, 16 Mar 2010 08:56:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: Re: [PATCH] block: make CONFIG_BLK_CGROUP visible
Message-ID: <20100316075623.GV5768@kernel.dk>
References: <4B9DA6F5.3070606@cn.fujitsu.com> <20100315115724.GK5768@kernel.dk> <4B9EE223.7020302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9EE223.7020302@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16 2010, Li Zefan wrote:
> Jens Axboe wrote:
> > On Mon, Mar 15 2010, Li Zefan wrote:
> >> Make the config visible, so we can choose from CONFIG_BLK_CGROUP=y
> >> and CONFIG_BLK_CGROUP=m when CONFIG_IOSCHED_CFQ=m.
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > What kernel is this against?
> > 
> 
> It's against linus' tree. I've just checked the block tree, and found
> it needs to be synced, otherwise this patch can't be applied on it.

OK, I'll hand apply it.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2IYWji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:39:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41959 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab2IYWjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:39:36 -0400
X-Sasl-enc: vWT02BgEmAfNy/o+m+QhBA4KQJcvbYwDXwa5bwwLZwGE 1348612775
Date: Tue, 25 Sep 2012 15:39:34 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: linux-next: manual merge of the tty tree with the workqueues tree
Message-ID: <20120925223934.GC6282@kroah.com>
References: <20120924163609.4f274e6340b92cea66eceb40@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924163609.4f274e6340b92cea66eceb40@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 04:36:09PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/omap-serial.c between commit 43829731dd37 ("workqueue:
> deprecate flush[_delayed]_work_sync()") from the workqueues tree and
> commit ac57e7f38ea6 ("serial: omap: Remove unnecessary checks from
> suspend/resume") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks fine to me, thanks.

greg k-h

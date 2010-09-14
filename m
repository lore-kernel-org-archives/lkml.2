Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0INEOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:14:51 -0400
Received: from kroah.org ([198.145.64.141]:58520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0INEO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:14:27 -0400
Date: Mon, 13 Sep 2010 21:08:53 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Mihai Don??u <mihai.dontu@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20100914040853.GC11972@kroah.com>
References: <20100914122824.9a6f9d8c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914122824.9a6f9d8c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 12:28:24PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/gadget/rndis.c between commit
> 7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> unnecessary return's from void functions") from the trivial tree and
> commit c8feb3bad134f927a624cc19da13f57627b905e2 ("USB: gadget: rndis: fix
> up coding style issues in the file") from the usb tree.
> 
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

Fix looks good to me, thanks for carrying this.

greg k-h

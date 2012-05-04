Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab2EDXSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:18:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55529 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab2EDXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:18:44 -0400
X-Sasl-enc: dlbcypDaSnSlMrloXmawsRH5gPEISCA7XXu2IcBGLojG 1336173523
Date: Fri, 4 May 2012 16:18:42 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20120504231842.GA9720@kroah.com>
References: <20120503144410.3aab6165a98e4f36bf50fcf5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503144410.3aab6165a98e4f36bf50fcf5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 02:44:10PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-tegra.c between commit ebf20de45304 ("EHCI: update
> PM methods in ehci-tegra.c") from the usb.current tree and commit
> fe375774bd88 ("usb: host: tegra: code clean up") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, that looks correct, I'll resolve the merge in my tree when -rc6
comes out.

greg k-h

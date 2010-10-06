Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0JFDf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:35:28 -0400
Received: from kroah.org ([198.145.64.141]:34859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab0JFDf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:35:27 -0400
Date: Tue, 5 Oct 2010 20:35:45 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20101006033545.GA5719@kroah.com>
References: <20101006141414.abf7431f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006141414.abf7431f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 02:14:14PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/musb/musb_gadget.c between commit
> 7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> unnecessary return's from void functions") from the trivial tree and
> commit 82cccbf2458e50dabf8b9946b3f0ef0e8d31711f ("usb: musb: gadget: kill
> unreachable code in musb_g_rx()") from the usb tree.
> 
> The latter also fixes the problem fixed in the former, so I just used the
> latter.

That sounds great, thanks for doing this.

greg k-h

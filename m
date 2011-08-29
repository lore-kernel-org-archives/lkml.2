Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1H2P5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:57:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43474 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763Ab1H2P5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:57:18 -0400
X-Sasl-enc: 7KKf4EzGnsm5ai9Yy7y84etdoifzvdmxT7sAjb29VNoc 1314633436
Date: Mon, 29 Aug 2011 08:52:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20110829155219.GA32601@kroah.com>
References: <20110825145206.4888b9f62a9bcbeeaf8678b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825145206.4888b9f62a9bcbeeaf8678b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 02:52:06PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/xhci-ring.c between commit 48df4a6fd8c4 ("xhci: Handle
> zero-length isochronous packets") from the usb.current tree and commit
> 29cc88979a88 ("USB: use usb_endpoint_maxp() instead of le16_to_cpu()")
> from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I've resolved this in my tree now so you should no longer need this.

greg k-h

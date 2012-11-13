Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2KMStQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:49:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49185 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636Ab2KMStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:49:13 -0500
X-Sasl-enc: sLMSIu6Iv70cn9cttoOd25K637t7mu1BxVGDiqo+R7RD 1352832552
Date: Tue, 13 Nov 2012 10:49:11 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Yongjun <weiyj.lk@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20121113184911.GC24793@kroah.com>
References: <20121113143732.624361eaf8ed2f4d0d64dd7d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113143732.624361eaf8ed2f4d0d64dd7d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:37:32PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/musb/ux500.c between commit 9a65d162e449 ("usb: musb: ux500:
> fix 'musbid' undeclared error in ux500_remove()") from the usb.current
> tree and commit 2f7711642559 ("usb: musb: remove hand-crafted id
> handling") from the usb tree.
> 
> The latter supercedes the former so I used that and can carry the fix as
> necessary (no action is required).

That is fine, thanks for doing this.

greg k-h

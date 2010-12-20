Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab0LTSpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:45:44 -0500
Received: from kroah.org ([198.145.64.141]:51939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab0LTSpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:45:42 -0500
Date: Mon, 20 Dec 2010 10:30:32 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20101220183032.GB23715@kroah.com>
References: <20101220162811.8c8d8d76.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220162811.8c8d8d76.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:28:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/gadget/composite.c between commit
> dbb442b85a1d82f91cfe0524c4f9b3a5196a10ca ("Revert "USB: gadget: Allow
> function access to device ID data during bind()"") from the usb.current
> tree and commit 78bff3c65df33da47e93736bd8847b694084e5a9 ("USB: gadget:
> composite: Typo fix") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, I'll need this later when this goes to Linus today and I merge
in the usb-next branch.

greg k-h

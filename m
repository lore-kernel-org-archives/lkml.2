Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2ISHRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:17:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34083 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144Ab2ISHRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:17:08 -0400
X-Sasl-enc: Yt/wxSXL9KZlnaEIsRjGGz5AoWF/WgK1cL5KogH2amgy 1348039027
Date: Wed, 19 Sep 2012 08:17:05 +0100
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: manual merge of the usb tree with the tty tree
Message-ID: <20120919071705.GC16905@kroah.com>
References: <20120919141636.99298d4d5e8501ec377e5594@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919141636.99298d4d5e8501ec377e5594@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 02:16:36PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/io_edgeport.c between commit adc8d746caa6 ("tty: move
> the termios object into the tty") from the tty tree and commit
> 984f68683298 ("USB: serial: io_edgeport.c: remove dbg() usage") from the
> usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks correct to me, thanks for the fix.

greg k-h

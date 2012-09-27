Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2I0OCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:02:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60081 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab2I0OCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:02:22 -0400
X-Sasl-enc: XhGBg7CiVw6IlFsXl8XCjFTobV7K0EdMQbNA1hyWoF+6 1348754541
Date: Thu, 27 Sep 2012 07:02:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Huang Shijie <shijie8@gmail.com>
Subject: Re: linux-next: manual merge of the char-misc tree with the  tree
Message-ID: <20120927140220.GA3148@kroah.com>
References: <20120927153119.d297af74a0dd70eb2e070830@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927153119.d297af74a0dd70eb2e070830@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:31:19PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/char/pcmcia/synclink_cs.c between commit f21ec3d2d46e ("serial:
> add a new helper function") from the tty tree and commit 221b7b5796b5
> ("pcmcia: synclink_cs: fix potential tty NULL dereference") from the
> char-misc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab1IUOI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:08:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37160 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab1IUOIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:08:22 -0400
X-Sasl-enc: YTNjBXK+4Ai6qImBChrnpe6CI7j1IqHeQ+gHbFcv8o+z 1316614101
Date: Wed, 21 Sep 2011 07:06:32 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>
Subject: Re: linux-next: manual merge of the tty tree with the powerpc tree
Message-ID: <20110921140632.GB19567@kroah.com>
References: <20110921145023.e38d553e218c8b5a2e71e9d8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921145023.e38d553e218c8b5a2e71e9d8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 02:50:23PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/8250.c between commit 7df5659eefad ("serial/8250: Move
> UPIO_TSI to powerpc") from the powerpc tree and commit 4834d0289785
> ("tty: serial8250: remove UPIO_DWAPB{,32}") from the tty tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks great, thanks.

greg k-h

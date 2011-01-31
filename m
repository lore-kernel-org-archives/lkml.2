Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1AaR7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:59:06 -0500
Received: from kroah.org ([198.145.64.141]:46232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1AaR7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:59:04 -0500
Date: Mon, 31 Jan 2011 09:56:14 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Torben Hohn <torbenh@gmx.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the tty.current tree with Linus'
 tree
Message-ID: <20110131175614.GA25739@kroah.com>
References: <20110131124633.3f49a8f9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131124633.3f49a8f9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:46:33PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty.current tree got a conflict in
> drivers/tty/tty_io.c between commit
> ac751efa6a0d70f2c9daef5c7e3a92270f5c2dff ("console: rename
> acquire/release_console_sem() to console_lock/unlock()") from Linus' tree
> and commit a2a6a822adc2a91c677cb60e9bc6ffe26fa90e9f ("tty: use
> for_each_console() and WARN() on sysfs failures") from the tty.current
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, I saw this today as well when I asked Linus to pull the changes.
He can do this fixup, or I will and ask him to re-pull if it's needed.

thanks,

greg k-h

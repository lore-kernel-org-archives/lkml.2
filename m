Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1BYRzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:55:52 -0500
Received: from kroah.org ([198.145.64.141]:56505 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab1BYRzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:55:51 -0500
Date: Fri, 25 Feb 2011 09:54:42 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20110225175442.GB13406@kroah.com>
References: <20110224164048.4d884c1d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224164048.4d884c1d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 04:40:48PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> scripts/Makefile.modbuiltin:25: drivers/char/pcmcia/ipwireless/Makefile: No such file or directory
> make[5]: *** No rule to make target `drivers/char/pcmcia/ipwireless/Makefile'.  Stop.
> 
> Caused by commit 282361a046edd9d58a134f358a3f65a7cb8655d9 ("tty: move
> ipwireless driver from drivers/char/pcmcia/ to drivers/tty/") which
> neglected to remove mention of ipwireless from
> drivers/char/pcmcia/Makefile.
> 
> I have used the tty tree from next-20110223 for today.

Now fixed, thanks.

greg k-h

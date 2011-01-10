Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1AJAzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 19:55:05 -0500
Received: from kroah.org ([198.145.64.141]:59693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1AJAzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 19:55:03 -0500
Date: Sun, 9 Jan 2011 16:56:01 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings after merge of the tty tree
Message-ID: <20110110005601.GA19570@kroah.com>
References: <20101221181158.53f62590.sfr@canb.auug.org.au>
 <20101221194204.GA11611@kroah.com>
 <20110110114959.691c20f1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110114959.691c20f1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 11:49:59AM +1100, Stephen Rothwell wrote:
> Hi Greg, Kay,
> 
> On Tue, 21 Dec 2010 11:42:04 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Dec 21, 2010 at 06:11:58PM +1100, Stephen Rothwell wrote:
> > > 
> > > After merging the tty tree, today's linux-next build (powerpc
> > > ppc64_defconfig) produced these warnings:
> > > 
> > > drivers/tty/tty_io.c: In function 'tty_init':
> > > drivers/tty/tty_io.c:3309: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result
> > > drivers/tty/vt/vt.c: In function 'vty_init':
> > > drivers/tty/vt/vt.c:2997: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result
> > > 
> > > Introduced by commit fbc92a3455577ab17615cbcb91826399061bd789 ("tty: add
> > > 'active' sysfs attribute to tty0 and console device").
> > 
> > Oops, Kay, care to make up a patch to fix these warnings?
> 
> These warnings are now in Linus' tree ...

Yes, Kay just sent me a patch to fix this, which I will queue up after
.38-rc1 is out.

thanks,

greg k-h

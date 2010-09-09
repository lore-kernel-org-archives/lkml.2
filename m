Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0IIPsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:48:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52553 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0IIPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:48:51 -0400
Date: Thu, 9 Sep 2010 08:48:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 6 (drivers/base/core)
Message-Id: <20100909084822.543b0268.randy.dunlap@oracle.com>
In-Reply-To: <20100907001407.GA10273@suse.de>
References: <20100906141727.646c68e7.sfr@canb.auug.org.au>
	<20100906164918.56487d92.randy.dunlap@oracle.com>
	<20100907001407.GA10273@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 17:14:07 -0700 Greg KH wrote:

> On Mon, Sep 06, 2010 at 04:49:18PM -0700, Randy Dunlap wrote:
> > On Mon, 6 Sep 2010 14:17:27 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100903:
> > > 
> > > The powerpc tree still has its build failure for which I applied a patch.
> > > 
> > > I still have a patch to the drivers-x86 tree to remove a Kconfig warning.
> > > 
> > > ----------------------------------------------------------------------------
> > 
> > 
> > when CONFIG_BLOCK is not enabled:
> > 
> > drivers/base/core.c:622: error: 'block_class' undeclared (first use in this function)
> > drivers/base/core.c:712: error: 'block_class' undeclared (first use in this function)
> > drivers/base/core.c:742: error: 'block_class' undeclared (first use in this function)
> 
> Ah, due to the CONFIG_SYSFS_DEPRECATED stuff.  I'll work on this later
> today if Kay doesn't beat me to it...


Still broken on 2010-SEP-09.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

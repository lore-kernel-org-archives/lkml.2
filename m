Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab0J0KGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:06:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:62258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0J0KGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,245,1286175600"; 
   d="scan'208";a="620761193"
Date: Wed, 27 Oct 2010 10:11:27 +0100
From: Alan Cox <alan@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (tty
 tree related)
Message-ID: <20101027101127.6fd49417@linux.intel.com>
In-Reply-To: <20101027110307.e754ef59.sfr@canb.auug.org.au>
References: <20100927153151.9bf66022.sfr@canb.auug.org.au>
	<20101027110307.e754ef59.sfr@canb.auug.org.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 11:03:07 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> On Mon, 27 Sep 2010 15:31:51 +1000 Stephen Rothwell
> <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > drivers/char/nozomi.c: In function 'ntty_ioctl':
> > drivers/char/nozomi.c:1831: warning: unused variable 'argp'
> > 
> > Introduced by commit dd612b1a8edb7fb3a117c388bfb520476e04ed18 ("tty:
> > icount changeover for other main devices").
> 
> This warning is now in Linus' tree ...

Already re-sent GregKH the fix. Guess it got eaten in the post last
time.

Alan



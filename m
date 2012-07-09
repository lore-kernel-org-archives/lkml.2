Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2GIOml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:42:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33621 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2GIOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:42:40 -0400
Date: Mon, 9 Jul 2012 07:42:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: talk about "Cc: stable@vger.kernel.org"
Message-ID: <20120709144234.GA3487@kroah.com>
References: <1341610730-6277-1-git-send-email-tytso@mit.edu>
 <20120706215944.GA6154@blackmetal.musicnaut.iki.fi>
 <alpine.DEB.2.00.1207090345540.8224@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207090345540.8224@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:48:14AM -0700, David Rientjes wrote:
> On Sat, 7 Jul 2012, Aaro Koskinen wrote:
> 
> > > I couldn't remember whether the canonical marking is stable@kernel.org
> > > or stable@vger.kernel.org, so I went looking, and discovered that it
> > > wasn't mentioned in the kernel sources.  You can find mention of it in
> > > Greg K-H's blog, but not everyone would necessarily find this blog
> > > entry.
> > 
> > It's documented in Documentation/stable_kernel_rules.txt.
> > 
> 
> I'm wondering if it would be helpful to the stable maintainers if we 
> explicitly asked that patches including "Cc: stable@vger.kernel.org" also 
> include the version number of the earliest version that the change should 
> be backported to?

It can be helpful, and in fact, is what is described in the above file
already, although it is often overlooked as it is only part of an
example.

But really, it's usually not needed, I'm more interested in getting more
maintainers to actually start marking patches for stable, that's the
larger problem we are dealing with.  Sorting out after-the-fact which
kernel version a patch is to be applied to is much simpler than finding
the patches in the first place.

thanks,

greg k-h

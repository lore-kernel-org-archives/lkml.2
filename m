Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2HDFjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 01:39:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38821 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752061Ab2HDFjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 01:39:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+8KHEexGy8eLDpVNUK6F3lU2WIlHCAGAzJj2KB5P
	H0V6nWqc+y5X26
Message-ID: <1344058736.9497.5.camel@marge.simpson.net>
Subject: Re: Gaming and the kernel
From: Mike Galbraith <efault@gmx.de>
To: valdis.kletnieks@vt.edu
Cc: Chris Jones <chrisjones@spin.net.au>, linux-kernel@vger.kernel.org,
        david@lang.hm
Date: Sat, 04 Aug 2012 07:38:56 +0200
In-Reply-To: <1344055742.6739.40.camel@marge.simpson.net>
References: <501C4CCE.8020806@spin.net.au> <501C545C.40601@gmail.com>
	 <501C6BDF.9090803@spin.net.au>
	 <alpine.DEB.2.02.1208031730100.8170@asgard.lang.hm>
	 <501C7225.5060405@spin.net.au> <168124.1344053522@turing-police.cc.vt.edu>
	 <1344055742.6739.40.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-04 at 06:49 +0200, Mike Galbraith wrote: 
> On Sat, 2012-08-04 at 00:12 -0400, valdis.kletnieks@vt.edu wrote: 
> > On Sat, 04 Aug 2012 10:51:49 +1000, Chris Jones said:
> > 
> > > documentation, hopefully things will work out. And this might actually
> > > be the kick in the rear-end that AMD and NVIDIA need to get into gear
> > > and start developer some useful and Windows equivalent hardware drivers
> > > for ALL their cards for Linux.
> > 
> > The truly ironic part is that the current NVidia binary blob driver that
> > everybody dislikes so much *IS* the "Windows equivalent" driver (in
> > fact, it's the same driver, with a Linux shim layer wrapped around it).
> 
> Hm.. so windows can be kept in kernel for a full second of IPI blasting
> all cores too.  That driver seems to work very nicely once things are
> running, but whatever the heck it does when you first fire up rendering
> is.. something to keep far far away from realtime tasks :)

That seems to have gotten about a ton better.  Worst just measured with
295.53 under 3.0-rt58 was 7.7ms, with typical being < 1ms.

-Mike


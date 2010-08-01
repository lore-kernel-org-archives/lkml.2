Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0HAAaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 20:30:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:53495 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab0HAA37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 20:29:59 -0400
Subject: Re: [PATCH 0/8] v3 De-couple sysfs memory directories from memory
 sections
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100731195506.GC4644@kroah.com>
References: <4C451BF5.50304@austin.ibm.com>
	 <1280554584.1902.31.camel@pasglop>  <20100731195506.GC4644@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 10:27:31 +1000
Message-ID: <1280622451.1902.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 12:55 -0700, Greg KH wrote:
> On Sat, Jul 31, 2010 at 03:36:24PM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2010-07-19 at 22:45 -0500, Nathan Fontenot wrote:
> > > This set of patches de-couples the idea that there is a single
> > > directory in sysfs for each memory section.  The intent of the
> > > patches is to reduce the number of sysfs directories created to
> > > resolve a boot-time performance issue.  On very large systems
> > > boot time are getting very long (as seen on powerpc hardware)
> > > due to the enormous number of sysfs directories being created.
> > > On a system with 1 TB of memory we create ~63,000 directories.
> > > For even larger systems boot times are being measured in hours.
> > 
> > Greg, Kame, how do we proceed with these ? I'm happy to put them in
> > powerpc.git with appropriate acks or will you take them ?
> 
> I thought there would be at least one more round of these patches based
> on the review comments, right?

Yes, but I was nontheless inquiring whether I should pick them up after
said repost :-)

> I'll be glad to take them when everyone agrees with them.

Ok, good, one less thing to worry about in powerpc patchwork :-)

Cheers,
Ben.

> thanks,
> 
> greg k-h



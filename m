Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0GaT6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:58:40 -0400
Received: from kroah.org ([198.145.64.141]:39086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab0GaT6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:58:39 -0400
Date: Sat, 31 Jul 2010 12:55:06 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] v3 De-couple sysfs memory directories from memory
	sections
Message-ID: <20100731195506.GC4644@kroah.com>
References: <4C451BF5.50304@austin.ibm.com> <1280554584.1902.31.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280554584.1902.31.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 03:36:24PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2010-07-19 at 22:45 -0500, Nathan Fontenot wrote:
> > This set of patches de-couples the idea that there is a single
> > directory in sysfs for each memory section.  The intent of the
> > patches is to reduce the number of sysfs directories created to
> > resolve a boot-time performance issue.  On very large systems
> > boot time are getting very long (as seen on powerpc hardware)
> > due to the enormous number of sysfs directories being created.
> > On a system with 1 TB of memory we create ~63,000 directories.
> > For even larger systems boot times are being measured in hours.
> 
> Greg, Kame, how do we proceed with these ? I'm happy to put them in
> powerpc.git with appropriate acks or will you take them ?

I thought there would be at least one more round of these patches based
on the review comments, right?

I'll be glad to take them when everyone agrees with them.

thanks,

greg k-h

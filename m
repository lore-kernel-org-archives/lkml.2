Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0GIRxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:53:40 -0400
Received: from kroah.org ([198.145.64.141]:43977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab0GIRxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:53:39 -0400
Date: Fri, 9 Jul 2010 08:59:41 -0700
From: Greg KH <greg@kroah.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [-next July 9 - s390 ] Badness at fs/sysfs/symlink.c:82 during
 qeth initalization
Message-ID: <20100709155941.GA2086@kroah.com>
References: <20100709150117.51612026.sfr@canb.auug.org.au>
 <4C36EF9C.7010804@in.ibm.com>
 <m1d3ux55od.fsf@fess.ebiederm.org>
 <4C36F974.4030608@in.ibm.com>
 <20100709142818.GB9041@kroah.com>
 <20100709173326.72674aea@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709173326.72674aea@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 05:33:26PM +0200, Martin Schwidefsky wrote:
> On Fri, 9 Jul 2010 07:28:18 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Jul 09, 2010 at 03:57:00PM +0530, Sachin Sant wrote:
> > > Eric W. Biederman wrote:
> > >>> With today's next(20100709) qeth interface fails to initialize
> > >>> with following Badness message:
> > >>>     sysfs: symlink across ns_types 0.0.6000/net:eth0 -> net/eth0
> > >>>     
> > >>
> > >> Is this with CONFIG_SYSFS_DEPRECATED set?
> > >>
> > >> I think I may have made my warning check a little extra strict.
> > >>   
> > > Yes.
> > >
> > > CONFIG_SYSFS_DEPRECATED=y
> > > CONFIG_SYSFS_DEPRECATED_V2=y
> > 
> > Why do you have those options enabled?  Does your userspace really
> > require them?  I want to remove those options soon, and it would be good
> > to find out what is still relying on them.
> > 
> > If you disable those options, does it then work?
> 
> The default configuration for s390 does not have the options enabled and
> with a recent userspace everything works just fine. From my point of view
> the two options can be removed.

Wonderful, thanks for letting me know.

Sachin, care to disable them in your image as well?

thanks,

greg k-h

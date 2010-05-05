Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934916Ab0EEQ1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:27:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:55865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934813Ab0EEQ1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:27:18 -0400
Date: Wed, 5 May 2010 09:24:59 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: linux-next: Tree for April 30 (CONFIG_SYSFS=n)
Message-ID: <20100505162459.GA20296@suse.de>
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
 <20100430105016.40b51636.randy.dunlap@oracle.com>
 <20100505091738.7ec27479.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505091738.7ec27479.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 09:17:38AM -0700, Randy Dunlap wrote:
> On Fri, 30 Apr 2010 10:50:16 -0700 Randy Dunlap wrote:
> 
> > On Fri, 30 Apr 2010 16:35:38 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100429:
> > 
> > 
> > When CONFIG_SYSFS is disabled:
> > 
> > include/linux/sysfs.h:330: error: parameter 1 ('type') has incomplete type
> 
> 
> Still have this in linux-next of May 5-2010.

Eric, this is due to your changes, care to fix it up?

thanks,

greg k-h

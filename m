Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab0EUPRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:17:01 -0400
Received: from kroah.org ([198.145.64.141]:58745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235Ab0EUPQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:16:48 -0400
Date: Fri, 21 May 2010 08:15:41 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ian Kent <raven@themaw.net>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: add devname module aliases to allow module on-demand
 auto-loading
Message-ID: <20100521151541.GA17332@kroah.com>
References: <1274371640.302.5.camel@yio.site>
 <1274440317.2291.1.camel@localhost>
 <1274441053.302.8.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274441053.302.8.camel@yio.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 01:24:13PM +0200, Kay Sievers wrote:
> On Fri, 2010-05-21 at 19:11 +0800, Ian Kent wrote:
> > On Thu, 2010-05-20 at 18:07 +0200, Kay Sievers wrote:
> 
> > > --- a/fs/autofs4/dev-ioctl.c
> > > +MODULE_ALIAS_MISCDEV(BTRFS_MINOR);
> > 
> > Is this a typo or am I missing something?
> 
> Yikes, sorry, that's just broken. New patch. Thanks a lot for checking.

Thanks, I've updated the patch in my tree to this version.

greg k-h

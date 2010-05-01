Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0EBENJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:13:09 -0400
Received: from kroah.org ([198.145.64.141]:37598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0EBENC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:13:02 -0400
Date: Sat, 1 May 2010 10:48:53 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Thery <benjamin.thery@bull.net>, NeilBrown <neilb@suse.de>
Subject: Re: linux-next: build failure after merge of the staging-next tree
Message-ID: <20100501174853.GA22217@kroah.com>
References: <20100430155205.a4171034.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430155205.a4171034.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 03:52:05PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/md/md.c: In function 'level_store':
> drivers/md/md.c:3029: error: too few arguments to function 'sysfs_get_dirent'
> 
> Caused by commit 262f8e4937e7b4a587923ca3c039a184668f49ec ("sysfs:
> Implement sysfs tagged directory support") from the driver-core tree
> interacting with commit fecc531e3cc0de60514d326c7d82f1075ed55888 ("md:
> manage redundancy group in sysfs when changing level") from the md.
> 
> I have applied this fixup patch for today and can carry it as necessary.

Thanks, that would be great.

> [This could have been avoided, of course, by creating a new API (maybe
> sysfs_get_dirent_tagged) and implementing the old API in terms of that].

Hm Eric, any thoughts?

thanks,

greg k-h

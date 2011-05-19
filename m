Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab1ESSGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:06:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35444 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933638Ab1ESSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:06:03 -0400
Date: Thu, 19 May 2011 19:05:58 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
Message-ID: <20110519180558.GJ3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
 <20110519163709.GH3702@shadowen.org>
 <87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 07:44:54PM +0200, Miklos Szeredi wrote:

> Forgot to attach the patch?

Yep, should be in your inbox now.

> >
> > With this in place I have been able to boot a Natty release live CD
> > image, and upgrade it in place to the latest and greatest of everything.
> > Very nice.  Thanks for your work continuing work on overlayfs.  It is
> > starting to look good enough to merge.
> >
> > Comments?
> 
> I'd be happier if the LSM module were fixed not to peek inside the inode
> structure.  Some filesystems (notably network ones) do not guarantee i_*
> to be up-to-date, relying on these is not a good idea.

I wonder what what the official way to get ownership information for an
inode is if we cannot rely on those.  I am happy to get the Yama LSM
fixed up if they are doing something wrong.

-apw

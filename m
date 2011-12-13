Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1LMF36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:29:58 -0500
Received: from cobra.newdream.net ([66.33.216.30]:46817 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1LMF3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=0iwhcosnUXwPsT0cjiEtFyYzF
	4oYzEE6SV4+e9ugOfaQ4naxKxpzxAatAHBrhgbYDETAt0c7UCLq7f80zoReaup57
	zV012X0S+Q4hcx7vIqsKZlLVL3YmGT3IYHoW7y1QxM9zZ9ZXeLdyt+7C6WDlahpY
	jJIfdgvWmZeya1AEe0=
Date: Mon, 12 Dec 2011 21:29:51 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>, roel <roel.kluin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org
Subject: Re: ceph, cifs, nfs, fuse: boolean and / or confusion
In-Reply-To: <20111212155423.24543d6a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1112122123040.17811@cobra.newdream.net>
References: <4EE688FC.8090606@gmail.com> <20111212152856.871a8301.akpm@linux-foundation.org>
 <1323733153.13849.17.camel@lade.trondhjem.org> <1323733511.13849.19.camel@lade.trondhjem.org>
 <20111212155423.24543d6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Andrew Morton wrote:
> On Mon, 12 Dec 2011 18:45:11 -0500
> Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > On Mon, 2011-12-12 at 18:39 -0500, Trond Myklebust wrote:
> > 
> > > As far as NFS is concerned, it reverts a regression. NFS only used to
> > > run revalidate_file_size() for SEEK_END prior to commit
> > > 06222e491e663dac939f04b125c9dc52126a75c4. I accept that we now also need
> > > to run it for SEEK_HOLE and SEEK_DATA, but we've never had to do so for
> > > SEEK_SET and SEEK_CUR.
> > 
> > BTW: The regression exists in 3.1, so this is probably a stable
> > candidate...
> > 
> 
> I'd prefer not to merge this one unless all four fs maintainers have
> reviewed and preferably tested it.  Also, in view of your earlier email
> the changelog for this patch needs updating for NFS and probably other
> filesystems.
> 
> So please prepare and send the NFS patch, with a Reported-by:roel?

I'll push a fix for the ceph bit through my tree.  Thanks, roel!

sage

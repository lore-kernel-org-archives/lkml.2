Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2K3BqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:46:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61400 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2K3BqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:46:12 -0500
Date: Thu, 29 Nov 2012 17:46:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peng Tao <tao.peng@emc.com>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
Message-ID: <20121130014607.GD13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-42-git-send-email-herton.krzesinski@canonical.com>
 <1353983604.4266.44.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353983604.4266.44.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:33:24AM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Peng Tao <bergwolf@gmail.com>
> > 
> > commit fe6e1e8d9fad86873eb74a26e80a8f91f9e870b5 upstream.
> > 
> > If applications use flock to protect its write range, generic NFS
> > will not do read-modify-write cycle at page cache level. Therefore
> > LD should know how to handle non-sector aligned writes. Otherwise
> > there will be data corruption.
> > 
> > Signed-off-by: Peng Tao <tao.peng@emc.com>
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> [...]
> 
> I notice that this fix is missing from 3.4, and will need backporting.

I don't trust myself with backporting this, as I got it wrong.  So if
one of the NFS developers wants to do this (same goes for the other NFS
patch), I'll gladly take it.

thanks,

greg k-h

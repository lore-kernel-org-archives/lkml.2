Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0HTQ7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:59:51 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52333 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0HTQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:59:49 -0400
Date: Fri, 20 Aug 2010 10:00:20 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: linux-next: Tree for August 16 (ceph)
In-Reply-To: <20100820095213.51bacb36.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.1008200959370.22373@cobra.newdream.net>
References: <20100816150420.7f3f8cfd.sfr@canb.auug.org.au>
 <20100816100808.ff0fa2b4.randy.dunlap@oracle.com>
 <20100820095213.51bacb36.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010, Randy Dunlap wrote:
> On Mon, 16 Aug 2010 10:08:08 -0700 Randy Dunlap wrote:
> 
> > On Mon, 16 Aug 2010 15:04:20 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > As the merge window has closed, let the flood commence. :-)
> > > 
> > > Changes since 20100813:
> > 
> > 
> > linux-next-20100816/net/ceph/debugfs.c:255: error: conflicting types for 'ceph_debugfs_client_init'
> > linux-next-20100816/include/linux/ceph/debugfs.h:29: note: previous declaration of 'ceph_debugfs_client_init' was here
> 
> 
> Same error still present in linux-next 20100820.

Sorry, I hadn't updated my for-next branch.  It's pushed to kernel.org 
now.

Thanks-
sage

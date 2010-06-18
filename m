Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0FRC7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:59:50 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:37436 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0FRC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:59:49 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH v2] d_ino considered harmful
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: David Dillow <dillowda@ornl.gov>, Valerie Aurora <vaurora@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <A8B216D0-06C5-4D85-9AA6-EB4C9E87D26B@oracle.com>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell> <1276721084.13788.53.camel@lap75545.ornl.gov> <30568.1276797848@jrobl> <A8B216D0-06C5-4D85-9AA6-EB4C9E87D26B@oracle.com>
Date: Fri, 18 Jun 2010 11:57:52 +0900
Message-ID: <7385.1276829872@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andreas Dilger:
> As the name implies, it is very extN specific. For Lustre 2.0 we use a  
> different method to get O(1) FID (inode number) to pathname(s)  
> lookup.  Each file stores an xattr with the {parent FID, filename}  
> tuples for each link to the file, whenever an inode is created,  
> linked, unlinked, or renamed.

Honestly speaking, this approach is the one which came to my mind when I
read David's mail. Andreas's approach and explanation is perfect as I
should admire.

Thank you
J. R. Okajima

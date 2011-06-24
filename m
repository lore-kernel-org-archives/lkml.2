Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267Ab1FXCGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:06:17 -0400
Received: from mx2.netapp.com ([216.240.18.37]:14838 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142Ab1FXCGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:06:16 -0400
X-IronPort-AV: E=Sophos;i="4.65,417,1304319600"; 
   d="scan'208";a="557991642"
Subject: Re: [34-longterm 100/247] NFS: fix the return value of
 nfs_file_fsync()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@kernel.org,
        linux-kernel@vger.kernel.org, stable-review@kernel.org
Date: Thu, 23 Jun 2011 22:05:59 -0400
In-Reply-To: <3853.1308880989@jrobl>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
	 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
	 <1308850515-15242-41-git-send-email-paul.gortmaker@windriver.com>
	 <3853.1308880989@jrobl>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Message-ID: <1308881159.30166.0.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 24 Jun 2011 02:06:00.0505 (UTC) FILETIME=[437EC290:01CC3213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 11:03 +0900, J. R. Okajima wrote: 
> Paul Gortmaker:
> > By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
> > close(2) became returning the non-zero value even if it went well.
> > nfs_file_fsync() should return 0 when "status" is positive.
> >
> > [PG: in 34, nfs_file_fsync is just a wrapper around nfs_do_fsync,
> >  so the related code and actual change lands in nfs_do_fsync here.]
> 
> In these 247 patches, I could not find the backport of
> 	af7fa16 2010-08-03 NFS: Fix up the fsync code
> If you bring the commit af7fa16 into 2.6.34.10, then you will need this
> one (0702099bd in upstream) too. Otherwise I am afraid it is
> unnecessary.
> But I'd ask a reply from Trond Myklebust.

I agree.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


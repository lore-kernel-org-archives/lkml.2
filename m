Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293Ab1FXCDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:03:17 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:42794 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142Ab1FXCDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:03:15 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [34-longterm 100/247] NFS: fix the return value of nfs_file_fsync()
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
In-Reply-To: <1308850515-15242-41-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com> <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com> <1308850515-15242-41-git-send-email-paul.gortmaker@windriver.com>
Date: Fri, 24 Jun 2011 11:03:09 +0900
Message-ID: <3853.1308880989@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul Gortmaker:
> By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
> close(2) became returning the non-zero value even if it went well.
> nfs_file_fsync() should return 0 when "status" is positive.
>
> [PG: in 34, nfs_file_fsync is just a wrapper around nfs_do_fsync,
>  so the related code and actual change lands in nfs_do_fsync here.]

In these 247 patches, I could not find the backport of
	af7fa16 2010-08-03 NFS: Fix up the fsync code
If you bring the commit af7fa16 into 2.6.34.10, then you will need this
one (0702099bd in upstream) too. Otherwise I am afraid it is
unnecessary.
But I'd ask a reply from Trond Myklebust.


J. R. Okajima

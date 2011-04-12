Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1DLL4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:56:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:52211 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1DLL4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:56:17 -0400
X-IronPort-AV: E=Sophos;i="4.64,195,1301900400"; 
   d="scan'208";a="540761788"
Subject: Re: O_EXCL in NFSv3
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20361.1302593733@jrobl>
References: <20361.1302593733@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Tue, 12 Apr 2011 07:56:11 -0400
Message-ID: <1302609371.10760.6.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 12 Apr 2011 11:56:16.0652 (UTC) FILETIME=[A1022CC0:01CBF908]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 16:35 +0900, J. R. Okajima wrote:
> Hello Trond,
> 
> The commit in v2.6.37
> 	c0204fd 2010-09-17 NFS: Clean up nfs4_proc_create()
> looks totally dropping O_EXCL flag from NFSv3.
> But fs/nfs/nfs3proc.c:nfs3_proc_create() and
> fs/nfsd/nfs3proc.c:nfsd3_proc_create() still expect O_EXCL to be passed.
> 
> And the commit log says "Clean up nfs4_proc_create()".
> Is this change for NFSv3 intentional?
> Actually O_EXCL in NFSv3 doesn't work in v2.6.37 and later.

Doesn't commit 8a0eebf66e3b1deae036553ba641a9c2bdbae678 (NFS: Fix NFSv3
exclusive open semantics) fix this? It should be in the stable tree.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


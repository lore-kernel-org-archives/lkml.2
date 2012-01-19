Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2ASPUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:20:13 -0500
Received: from mx2.netapp.com ([216.240.18.37]:19986 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab2ASPUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:20:10 -0500
X-IronPort-AV: E=Sophos;i="4.71,536,1320652800"; 
   d="scan'208";a="618388855"
Message-ID: <1326986392.6114.1.camel@lade.trondhjem.org>
Subject: Re: [PATCH 0/5] SUNRPC: make caches network namespace aware
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Dr James Bruce Fields <bfields@redhat.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Thu, 19 Jan 2012 10:19:52 -0500
In-Reply-To: <20120119144517.9957.59143.stgit@localhost6.localdomain6>
References: <20120119144517.9957.59143.stgit@localhost6.localdomain6>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jan 2012 15:19:53.0663 (UTC) FILETIME=[CB679CF0:01CCD6BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 18:48 +0400, Stanislav Kinsbursky wrote: 
> One more step towards to "NFS in container".
> With this patch set caches are allocated per network namespace.
> 
> The following series consists of:
> 
> ---
> 
> Stanislav Kinsbursky (5):
>       SUNRPC: cache creation and destruction routines introduced
>       SUNRPC: create unix gid cache per network namespace
>       SUNRPC: create GSS auth cache per network namespace
>       SUNRPC: ip map cache per network namespace cleanup
>       SUNRPC: generic cache register routines removed

The patches look good, and I've applied them for now in my 'devel'
branch so we can test them, but I'd like to get an Ack/Nack from Bruce
before committing to merging them.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab0LNVeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:34:46 -0500
Received: from mx2.netapp.com ([216.240.18.37]:62662 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760249Ab0LNVen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:34:43 -0500
X-IronPort-AV: E=Sophos;i="4.59,344,1288594800"; 
   d="scan'208";a="494908600"
Subject: Re: [PATCH] net/sunrpc/auth_gss/gss_krb5_crypto.c: Use normal
 negative error value return
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Joe Perches <joe@perches.com>, Neil Brown <neilb@suse.de>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101214211922.GJ24828@fieldses.org>
References: <1289786891.16461.102.camel@Joe-Laptop>
	 <20101214211922.GJ24828@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Tue, 14 Dec 2010 16:34:25 -0500
Message-ID: <1292362465.14641.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 14 Dec 2010 21:34:27.0013 (UTC) FILETIME=[AEEAEF50:01CB9BD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 16:19 -0500, J. Bruce Fields wrote:
> On Sun, Nov 14, 2010 at 06:08:11PM -0800, Joe Perches wrote:
> > And remove unnecessary double semicolon too.
> > 
> > No effect to code, as test is != 0.
> 
> Hm, the error return's actually ignored.  But OK.  Applying to my tree
> for 2.6.38 assuming nobody else has picked it up.

There are also gems such as

u32 ret = -EINVAL;

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


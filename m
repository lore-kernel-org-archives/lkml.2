Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2BMJBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:01:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2BMJBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:01:31 -0500
Message-ID: <1329123676.2647.43.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, Greg KH <greg@kroah.com>
Date: Mon, 13 Feb 2012 17:01:16 +0800
In-Reply-To: <20120213161537.3cf109d3f9c4c577f8fcb789@canb.auug.org.au>
References: <20120213161537.3cf109d3f9c4c577f8fcb789@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 16:15 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> drivers/staging/zcache/zcache-main.c between commit a49aeb1de585
> ("staging: zcache: replace xvmalloc with zsmalloc") (and mayb others)
> from the staging tree and commit 1edbcaee3bbe ("zcache: remove the second
> argument of k [un]map_atomic()") from the kmap_atomic tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good.

Thanks!


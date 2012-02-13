Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2BMJA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:00:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2BMJA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:00:57 -0500
Message-ID: <1329123642.2647.42.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>
Date: Mon, 13 Feb 2012 17:00:42 +0800
In-Reply-To: <20120213162008.a9a3092bec076bcf0f05c261@canb.auug.org.au>
References: <20120213162008.a9a3092bec076bcf0f05c261@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 16:20 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> drivers/staging/zram/zram_drv.c between commit fd1a30dea194 ("staging:
> zram: replace xvmalloc with zsmalloc") from the staging tree and commit
> ea81cfe7d7fb ("zram: remove the second argument of k[un]map_atomic()")
> from the kmap_atomic tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> 

Looks good, thanks!


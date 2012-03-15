Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab2COIrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760273Ab2COIrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:47:36 -0400
Message-ID: <1331801233.30489.7.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the md
 tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Date: Thu, 15 Mar 2012 16:47:13 +0800
In-Reply-To: <20120315170943.378ed2719af547d5b4419e6f@canb.auug.org.au>
References: <20120315170943.378ed2719af547d5b4419e6f@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 17:09 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> drivers/md/bitmap.c between commit 83a191d7b09d ("md/bitmap: remove some
> pointless locking") from the md tree and commit 63716d51774d ("md: remove
> the second argument of k[un]map_atomic()") from the kmap_atomic tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Ok, looks good to me.

Thanks!


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2BIIkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:40:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab2BIIkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:40:12 -0500
Message-ID: <1328776797.20628.18.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 staging.current tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org
Date: Thu, 09 Feb 2012 16:39:57 +0800
In-Reply-To: <20120209144807.78f2807f594959f3836cf2eb@canb.auug.org.au>
References: <20120209144807.78f2807f594959f3836cf2eb@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 14:48 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> drivers/staging/zcache/zcache-main.c between commit 2a4830110b90
> ("staging: zcache: fix serialization bug in zv stats") from the
> staging.current tree and commit a3a2486aeadb ("zcache: remove the second
> argument of k [un]map_atomic()") from the kmap_atomic tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good. Thanks, Stephen!

Andrew, Greg,

As Linus doesn't want to merge my tree, could any of you take my patches
in kmap_atomic tree?

Thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2CBFvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:51:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab2CBFvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:51:41 -0500
Message-ID: <1330667490.2539.12.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ". Seth Jennings" <sjenning@linux.vnet.ibm.com>
Date: Fri, 02 Mar 2012 13:51:30 +0800
In-Reply-To: <20120301170731.e14fb63e606a8e67b0cb919a@canb.auug.org.au>
References: <20120301170731.e14fb63e606a8e67b0cb919a@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 17:07 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> drivers/staging/zcache/zcache-main.c between various commits from the
> staging tree and commit 1edbcaee3bbe ("zcache: remove the second argument
> of k[un]map_atomic()") from the kmap_atomic tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Hi, Stephen,

Sorry for the delay, it looks correct to me.

Thanks!


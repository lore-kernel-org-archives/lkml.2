Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2BMJAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:00:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab2BMJAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:00:37 -0500
Message-ID: <1329123607.2647.40.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>
Date: Mon, 13 Feb 2012 17:00:07 +0800
In-Reply-To: <20120213162752.b4207f13fb95d7e4db1b5ba2@canb.auug.org.au>
References: <20120213162752.b4207f13fb95d7e4db1b5ba2@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 16:27 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> drivers/staging/zram/xvmalloc.c between commit b154ff05e1b0 ("staging:
> zram: remove xvmalloc") from the staging tree and commit ea81cfe7d7fb
> ("zram: remove the second argument of k[un]map_atomic()") from the
> kmap_atomic tree.
> 
> The former removed the file, so I did that.

Ok, thanks!


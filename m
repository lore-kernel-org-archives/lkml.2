Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab2AFIRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:17:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909Ab2AFIRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:17:37 -0500
Message-ID: <1325837842.9815.33.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 staging tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, Greg KH <greg@kroah.com>
Date: Fri, 06 Jan 2012 16:17:22 +0800
In-Reply-To: <20120106184055.3669727def69e424cd98690d@canb.auug.org.au>
References: <20120106184055.3669727def69e424cd98690d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 18:40 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got conflicts in
> drivers/net/hyperv/netvsc_drv.c and drivers/net/hyperv/rndis_filter.c
> between commit 453263421f88 ("net/hyperv: Remove unnecessary kmap_atomic
> in netvsc driver") from the staging tree and commit e91cd643d15d ("hv:
> remove the second argument of k[un]map_atomic()") from the kmap_atomic
> tree.
> 
> The former removed the code modified by the latter, so I did that.

This makes sense for me.

Thanks for fixing it!



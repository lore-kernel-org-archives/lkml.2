Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2BPNrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:47:22 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4635 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab2BPNrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:47:20 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: linux-next: manual merge of the net-next tree with the net
 tree
From: "Yuval Mintz" <yuvalmin@broadcom.com>
To: sfr@canb.auug.org.au
cc: davem@davemloft.net, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eilong@broadcom.com,
        eric.dumazet@gmail.com
In-Reply-To: <1329391450.16698.27.camel@lb-tlvb-eilong.il.broadcom.com>
References: <20120216123803.8efe3d23eee5c3a80aceef61@canb.auug.org.au>
 <1329391450.16698.27.camel@lb-tlvb-eilong.il.broadcom.com>
Organization: Broadcom
Date: Thu, 16 Feb 2012 15:47:04 +0200
Message-ID: <1329400024.16698.36.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 6323D56E50423692784-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 13:24 +0200, Yuval Mintz wrote:
> On Wed, 2012-02-15 at 17:38 -0800, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the net-next tree got a conflict in
> > drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c between commit
> > 66d885cba670 ("bnx2x: fix bnx2x_storm_stats_update() on big endian") from
> > the net tree and commit 1355b704b9ba ("bnx2x: consistent statistics after
> > internal driver reload") from the net-next tree.
> > 
> > I fixed it up (see below) but suspect that there may be more needed.
> 
> Hey Stephen,
> 
> I don't fully understand your merge - it seems to create a mash between
> the "bnx2x: fix bnx2x_storm_stats_update() on big endian" patch in net,
> and the "bnx2x: consistent statistics after internal driver reload"
> patch in net-next.
> 
> If the purpose of this merge is simply to update net-next tree with the
> changes from "bnx2x: fix bnx2x_storm_stats_update() on big endian", you
> might consider the following patch:
> 
> Subject: [PATCH 1/1] bnx2x: merge net --> net-next
> From: Mintz Yuval <yuvalmin@broadcom.com>
> 
> This patch applies the changes made in the patch
> "bnx2x: fix bnx2x_storm_stats_update() on big endian" to net into net-next.
> 
> Signed-off-by: Mintz Yuval <yuvalmin@broadcom.com>
> Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
> ---
We need of course to thank Eric Dumazet <eric.dumazet@gmail.com> for the
original patch.



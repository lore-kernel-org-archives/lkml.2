Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1HWSNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:13:50 -0400
Received: from fep27.mx.upcmail.net ([62.179.121.47]:37550 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1HWSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:13:43 -0400
X-SourceIP: 84.74.12.24
From: Niklaus Giger <niklaus.giger@member.fsf.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net tree with the  tree
Date: Tue, 23 Aug 2011 20:10:44 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-686-pae; KDE/4.6.5; i686; ; )
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@gmail.com>, Tony Breeds <tony@bakeyournoodle.com>
References: <20110822115118.e5d97beb22befc4ba9396e9d@canb.auug.org.au>
In-Reply-To: <20110822115118.e5d97beb22befc4ba9396e9d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108232010.46421.niklaus.giger@member.fsf.org>
X-Cloudmark-Analysis: v=1.1 cv=jqrf5qXv5urL2URZ3a9OklEvUdrM81ZtB3GWlHLPCVk= c=1 sm=0 a=iz0-Qgh3t-8A:10 a=YAVIidEF13QA:10 a=kj9zAlcOel0A:10 a=kRAKLi_00tmjMi9RwEMA:9 a=bvvhazy6DzzRVOkDMHMA:7 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> arch/powerpc/configs/40x/hcu4_defconfig between commit 9fcd768d0cc8
> ("powerpc/40x: Remove obsolete HCU4 board") from the 4xx tree and commit
> 3b3bceef26f8 ("net: fix IBM EMAC driver after rename") from the net tree.
> 
> The former commit removes the file, so I just did that.
Thanks!

Best regards

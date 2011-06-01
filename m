Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1FAG0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:26:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34326 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab1FAG0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:26:31 -0400
Message-ID: <4DE5DB95.8010106@kernel.dk>
Date: Wed, 01 Jun 2011 08:26:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20110601110132.5485aba4.sfr@canb.auug.org.au>
In-Reply-To: <20110601110132.5485aba4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 03:01, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/block/xen-blkback/blkback.c: In function 'xen_blkif_init':
> drivers/block/xen-blkback/blkback.c:812:6: error: 'blkback' undeclared (first use in this function)
> 
> Caused by commit 2a46117c6050 ("xen/blkback: potential null dereference
> in error handling").
> 
> I have used the block tree from next-20110530 for today.

Damn, sorry Stephen. Konrad, I'm rolling my tree back as not to
introduce bisection breakage in the tree. JFYI, so rebase yours as well
and lets try again.

-- 
Jens Axboe


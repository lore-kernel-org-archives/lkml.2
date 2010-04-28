Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab0D1HWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:22:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49584 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0D1HWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:22:23 -0400
Date: Wed, 28 Apr 2010 09:22:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Hutchings <bhutchings@solarflare.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       =?iso-8859-1?B?Ikr2cm4gRW5nZWwi?= <joern@logfs.org>
Subject: Re: linux-next: manual merge of the block tree with the mtd tree
Message-ID: <20100428072222.GP27497@kernel.dk>
References: <20100428132423.0cb8bd44.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428132423.0cb8bd44.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28 2010, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> drivers/mtd/mtdcore.c between commit
> b520e412faaaad35641aeedd6059179f9f1b393c ("mtd: Replace static array of
> devices with an idr structure") from the mtd tree and commit
> a33eb6b91034c95b9b08576f68be170f995b2c7d ("Move mtd_bdi_*mappable to
> mtdcore.c") from the block tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks, looks good. It should go away soon, as the below bits are for
2.6.34.

-- 
Jens Axboe


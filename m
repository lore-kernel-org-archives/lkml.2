Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0HIJKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:10:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:21246 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0HIJKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:10:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,341,1278313200"; 
   d="scan'208";a="543143556"
Date: Mon, 9 Aug 2010 11:10:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20100809091019.GA2513@sortiz-mobl>
References: <20100809114042.7beb076a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809114042.7beb076a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Aug 09, 2010 at 11:40:42AM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/mfd/tps6586x.c: In function 'tps6586x_add_subdevs':
> drivers/mfd/tps6586x.c:272: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:273: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:275: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:275: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:278: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c: In function 'tps6586x_i2c_probe':
> drivers/mfd/tps6586x.c:324: warning: passing argument 2 of 'tps6586x_add_subdevs' from incompatible pointer type
> drivers/mfd/tps6586x.c:265: note: expected 'struct tps6586x_platform_data *' but argument is of type 'struct tps6586x_platform_data *'
> drivers/mfd/tps6586x.c:330: error: dereferencing pointer to incomplete type
> 
> Caused by commit 8232c2794cf0e39b38d089eff49500461ecdbb8f ("mfd: Add
> TPS6586x driver").  "struct tps6586x_platform_data" is not defined
> anywhere ...
Sorry about that, it should be all fixed now.

Cheers,
Samuel.


> I have used the mfd tree from next-20100807 for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Intel Open Source Technology Centre
http://oss.intel.com/

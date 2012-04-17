Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2DQBuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:50:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25897 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab2DQBuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:50:10 -0400
Date: Mon, 16 Apr 2012 21:45:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20120417014503.GA1151@phenom.dumpdata.com>
References: <20120417104430.d1844b17e4c7d5ffb132f816@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417104430.d1844b17e4c7d5ffb132f816@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F8CCC4C.003B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 10:44:30AM +1000, Stephen Rothwell wrote:
> Hi Konrad,
> 
> Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/block/xen-blkback/xenbus.c: In function 'xen_blkbk_discard':
> drivers/block/xen-blkback/xenbus.c:419:4: warning: passing argument 1 of 'dev_warn' makes pointer from integer without a cast [enabled by default]
> include/linux/device.h:894:5: note: expected 'const struct device *' but argument is of type 'long int'
> 
> Introduced by commit 3389bb8bf761 ("xen/blkback: Make optional features
> be really optional").  Passing "dev-dev" to dev_warn() was hopefully not
> intended ...

No it was not. Not even sure how that mistake passed my compile test.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



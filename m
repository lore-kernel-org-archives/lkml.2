Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0FAHWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:22:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0FAHWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:22:35 -0400
Date: Tue, 1 Jun 2010 09:22:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: linux-next: build failure after merge of the hwpoison tree
Message-ID: <20100601072233.GB30556@basil.fritz.box>
References: <20100601160050.91404d78.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601160050.91404d78.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 04:00:50PM +1000, Stephen Rothwell wrote:
> Hi Andi,
> 
> After merging the hwpoison tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "PageHuge" [mm/hwpoison-inject.ko] undefined!

Thanks Stephen. I pushed out an updated tree including
the missing EXPORT_SYMBOL. So hopefully tomorrow it will
work.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

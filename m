Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1EPSQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:16:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42942 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1EPSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:16:03 -0400
Date: Mon, 16 May 2011 14:08:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>,
        Anantha Idapalapati <aidapalapati@nvidia.com>
Subject: Re: linux-next: build failure after merge of the wireless tree
Message-ID: <20110516180817.GC6551@tuxdriver.com>
References: <20110516120227.27a5a343.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516120227.27a5a343.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:02:27PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "clk_get" [net/rfkill/rfkill-gpio.ko] undefined!
> ERROR: "clk_enable" [net/rfkill/rfkill-gpio.ko] undefined!
> ERROR: "clk_put" [net/rfkill/rfkill-gpio.ko] undefined!
> ERROR: "clk_disable" [net/rfkill/rfkill-gpio.ko] undefined!
> 
> Caused by commit 165d625850e8 ("net: rfkill: add generic gpio rfkill
> driver").
> 
> I have used the wireless tree from next-20110513 for today.

Yeah, I think I'm going to drop this for now until we can sort this out.

> P.S. is the Author information for that commit correct?  It has a From:
> line near the bottom of the commit message.

That does look strange.  I'll ask Rhyland to make that more clear.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

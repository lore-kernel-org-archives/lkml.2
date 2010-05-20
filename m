Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0ETBqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:46:33 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60322 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab0ETBqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:46:31 -0400
Date: Thu, 20 May 2010 02:46:28 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pannaga Bhushan <p.bhushan@samsung.com>
Subject: Re: linux-next: manual merge of the samsung tree with the  tree
Message-ID: <20100520014628.GL4720@trinity.fluff.org>
References: <20100520110411.c16ea156.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520110411.c16ea156.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 11:04:11AM +1000, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next merge of the samsung tree got a conflict in
> arch/arm/mach-s5pv210/gpiolib.c between commit
> ea5f50706385b61c1c0d24271bbe7c6e93129fbc ("ARM: S5PV210: Add GPIOlib
> support") from Linus' tree and commit
> 026fcae436e846b0cc1db8d4af11890dfdde3689 ("ARM: S5PV210: Add S5PV210 GPIO
> support") from the samsung tree.
> 
> Two versions of the same commit.  I used the version in Linus' tree as
> that was dated later.

sorry, the tree that went to linus had that one replaced due to a minor
bug in the GPH banks that got fixed. Decided to replace the patch than
put a patch ontop.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.


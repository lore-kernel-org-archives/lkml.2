Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1GaHpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:45:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:57996 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1GaHpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:45:03 -0400
Date: Sun, 31 Jul 2011 03:44:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731074454.GI31842@windriver.com>
References: <20110729170659.91ad989caa407854c5e269a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729170659.91ad989caa407854c5e269a2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 17:06) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mmc/host/sdhci-of-esdhc.c:110:1: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
[...]
> drivers/mmc/host/sdhci-of-hlwd.c:82:1: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
[...]
> drivers/power/max8997_charger.c:205:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
[...]
> drivers/regulator/aat2870-regulator.c:231:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
[...]

> I have just left these in fixed for now.  Please let me know if some of
> them can't be fixed in your tree and I will spin fixes for them in
> linux-next.

The mmc ones I can fix; the power/regulator ones are not in master yet.
But since they need module.h, the fix can be applied by their respective
tree owner as well (vs. ones needing export.h -- which presents a minor
chicken-and-egg problem).

Thanks,
Paul.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



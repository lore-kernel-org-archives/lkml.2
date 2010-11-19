Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0KSQIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:08:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:35222 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0KSQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:08:30 -0500
Date: Fri, 19 Nov 2010 17:08:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?=22Uwe_Kleine-K=F6nig=22?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
In-Reply-To: <20101109132725.2e17ae65.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1011191708130.7420@pobox.suse.cz>
References: <20101109132725.2e17ae65.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/blackfin/mach-bf538/include/mach/defBF539.h,
> arch/blackfin/mach-bf518/include/mach/defBF51x_base.h and
> arch/blackfin/mach-bf527/include/mach/defBF52x_base.h between various
> commits from the blackfin tree and commit
> b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
> typos") from the trivial tree.
> 
> I just used the versions from the blackfin tree for now since they moved
> large amounts of code around and deleted the latter 2 files.

I have reverted those hunks in my tree, so it should be conflict-less now.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

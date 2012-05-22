Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2EVJQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:16:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab2EVJQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:16:11 -0400
Date: Tue, 22 May 2012 11:16:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
In-Reply-To: <20120522145432.aa4d97df7f08af54229f1338@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1205221115390.16396@pobox.suse.cz>
References: <20120522145432.aa4d97df7f08af54229f1338@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/mips/lantiq/xway/gpio_ebu.c arch/mips/lantiq/xway/gpio_stp.c between
> commit 5238f7bc3566 ("GPIO: MIPS: lantiq: move gpio-stp and gpio-ebu to
> the subsystem folder") from the  tree and commit 6997991ab0db ("mips: Fix
> printk typos in arc/mips") from the trivial tree.
> 
> The typos fixed in the latter probably need to be applied to the renamed
> files drivers/gpio/gpio-mm-lantiq.c and drivers/gpio/gpio-stp-xway.c
> (resp).
> 
> I have removed the old versions.

I will probably keep this trivial conflict for Linus to resolve. Thanks,

-- 
Jiri Kosina
SUSE Labs

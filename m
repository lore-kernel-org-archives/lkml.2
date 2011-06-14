Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1FNIm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:42:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:35836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab1FNIm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:42:57 -0400
Date: Tue, 14 Jun 2011 10:42:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
In-Reply-To: <20110614143108.f7c19c54.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1106141042400.22872@pobox.suse.cz>
References: <20110614143108.f7c19c54.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> sound/soc/fsl/fsl_ssi.c between commit 147dfe90f730 ("ASoC: p1022ds: fix
> incorrect referencing of device tree properties") from the sound tree and
> commit 28f65c11f2ff ("treewide: Convert uses of struct resource to
> resource_size(ptr)") from the trivial tree.
> 
> The former supercedes the latter.

I have dropped the hunk from my tree, thanks for reporting.

-- 
Jiri Kosina
SUSE Labs

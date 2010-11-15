Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0KOMkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 07:40:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:34643 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab0KOMkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:40:42 -0500
Date: Mon, 15 Nov 2010 13:40:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?=22Uwe_Kleine-K=F6nig=22?= 
	<u.kleine-koenig@pengutronix.de>,
        Jing Huang <huangj@brocade.com>
Subject: Re: linux-next: manual merge of the trivial tree with Linus' tree
In-Reply-To: <20101109133155.e979a39b.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1011151340060.7420@pobox.suse.cz>
References: <20101109133155.e979a39b.sfr@canb.auug.org.au>
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
> drivers/scsi/bfa/bfa_fcpim.c between commit
> 5fbe25c7a664601666895e8f95eaa59bd9741392 ("[SCSI] bfa: fix comments for c
> files") from Linus' tree and commit
> b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
> typos") from the trivial tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thank you Stephen, I think that's probably best thing to do here.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

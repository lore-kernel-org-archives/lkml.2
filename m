Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0GKUlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 16:41:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0GKUlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 16:41:50 -0400
Date: Sun, 11 Jul 2010 22:41:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amerigo Wang <amwang@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?ISO-8859-15?Q?=22Uwe_Kleine-K=F6nig=22?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the trivial tree with the v4l-dvb
 tree
In-Reply-To: <20100706152529.371c7800.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1007112241280.4741@pobox.suse.cz>
References: <20100706152529.371c7800.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jul 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/media/video/ov511.c between commit
> b2bde15c455d09057dc7bd9f5b9ed67b9ac99b8a ("V4L/DVB: Remove obsolete ov511
> driver") from the v4l-dvb tree and commit
> 421f91d21ad6f799dc7b489bb33cc560ccc56f98 ("fix typos concerning "initiali
> [zs]e"") from the trivial tree.
> 
> The former just removes the file, so I removed it.

Hi Stephen,

thanks for reporting it, I have reverted the drivers/media/video/ov511.c 
hunk.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

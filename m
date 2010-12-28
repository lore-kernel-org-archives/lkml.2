Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0L1NS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 08:18:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab0L1NSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 08:18:25 -0500
Date: Tue, 28 Dec 2010 14:18:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the trivial tree with the v4l-dvb
 tree
In-Reply-To: <20101228114744.e628825a.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1012281417570.16569@pobox.suse.cz>
References: <20101228114744.e628825a.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/media/video/zoran/zoran.h between commit
> 8221f9b5fa3e08ba35378f08f2a606156e685916 ("[media] zoran: remove V4L1
> compat code and zoran custom ioctls") from the v4l-dvb tree and commit
> b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
> typos") from the trivial tree.
> 
> The former removed the code modified by the latter, so I used the former.

On Tue, 28 Dec 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/staging/stradis/stradis.c between commit
> aef01debdfad83ab71a83b7af8cd90203404c1aa ("[media] cpia, stradis: remove
> deprecated V4L1 drivers") from the v4l-dvb tree and commit
> b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
> typos") from the trivial tree.
> 
> The former removed the file modified by the latter, so I removed the file.

Hi Stephen,

I have dropped both hunks, so the conflict should be gone now.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

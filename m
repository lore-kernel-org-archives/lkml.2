Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2JPGvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:51:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51916 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2JPGvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:51:52 -0400
Date: Tue, 16 Oct 2012 08:51:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the cortex tree with Linus' tree
Message-ID: <20121016065149.GO639@pengutronix.de>
References: <20121016132052.0ac9f1f6b3fcbe946503793c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121016132052.0ac9f1f6b3fcbe946503793c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 01:20:52PM +1100, Stephen Rothwell wrote:
> Hi Uwe,
> 
> Today's linux-next merge of the cortex tree got a conflict in
> arch/arm/kernel/process.c between commit 9e14f828ee4a ("arm: split
> ret_from_fork, simplify kernel_thread() [based on patch by rmk]") from
> Linus' tree and commit 2f3e7d3436cb ("Cortex-M3: Add support for
> exception handling") from the cortex tree.
> 
> I have no idea how to fix this up, so I have just dropped this tree for
> today.
I'll look into it and rebase accordingly.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

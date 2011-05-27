Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab1E0Hxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:53:46 -0400
Received: from smtp.nokia.com ([147.243.128.26]:41609 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab1E0Hxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:53:45 -0400
Subject: Re: linux-next: manual merge of the mtd tree with Linus' tree
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20110527140039.9bce4a2d.sfr@canb.auug.org.au>
References: <20110527140039.9bce4a2d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 27 May 2011 10:47:44 +0300
Message-ID: <1306482464.2785.154.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 14:00 +1000, ext Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next merge of the mtd tree got a conflict in
> drivers/mtd/maps/physmap.c between commit b7281ca2a4b0 ("ARM: 6904/1:
> MTD: Add integrator-flash feature to physmap") from Linus' tree and
> commit 984e6d8ec5ab ("mtd: physmap: convert to mtd_device_register()")
> from the mtd tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Yes, this looks right, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


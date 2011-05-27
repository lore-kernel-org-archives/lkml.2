Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab1E0Hsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:48:54 -0400
Received: from smtp.nokia.com ([147.243.1.47]:47000 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab1E0Hsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:48:52 -0400
Subject: Re: linux-next: manual merge of the mtd tree with Linus' tree
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20110527140018.993fe260.sfr@canb.auug.org.au>
References: <20110527140018.993fe260.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 27 May 2011 10:43:44 +0300
Message-ID: <1306482224.2785.153.camel@localhost>
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
> drivers/mtd/maps/integrator-flash.c between commit adf0040096e4 ("ARM:
> 6906/1: MTD: Remove integrator-flash") from Linus' tree and commit
> ee0e87b174bb ("mtd: convert remaining users to mtd_device_register()")
> from the mtd tree.
> 
> The former removes the file updated by the latter, so I just removed it.

Yes, this is right, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


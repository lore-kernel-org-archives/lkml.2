Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0GLVyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:54:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab0GLVyb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007121619100.10598@xanadu.home>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
	<alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
	<20100614083214.GA2104@pengutronix.de>
	<20100630104043.GG11746@pengutronix.de>
	<20100712155518.GA24144@pengutronix.de>
	<AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com>
	<20100712173228.GC9897@n2100.arm.linux.org.uk>
	<AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com>
	<20100712200604.GD9897@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1007121619100.10598@xanadu.home>
Date: Mon, 12 Jul 2010 14:54:24 -0700
Message-ID: <AANLkTikxRqg2bFiCr7zwvU0pQ5LPGVdHiFdnQowVx3h6@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 1:29 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>
> For the record, I do support Uwe's work too.  I do wish it could go in
> now so that from that point going forward we could only focus on
> improving the thing instead of having to care about implications during
> the merge window.

Ok, I merged it. I do love the diffstat. And while it may not be
optimal or a final solution, nobody seems to hate it either.

           Linus

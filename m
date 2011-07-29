Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab1G2EKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 00:10:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:57910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1G2EKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 00:10:35 -0400
Message-ID: <4E32329E.2010203@infradead.org>
Date: Fri, 29 Jul 2011 01:10:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Drokin <green@linuxhacker.ru>, Tony Lindgren <tony@atomide.com>,
        Linus <torvalds@linux-foundation.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with Linus' tree
References: <20110729131735.911ce0d16367933036fa9e6f@canb.auug.org.au>
In-Reply-To: <20110729131735.911ce0d16367933036fa9e6f@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-07-2011 00:17, Stephen Rothwell escreveu:
> Hi Mauro,
> 
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> arch/arm/mach-omap2/board-rx51-peripherals.c between commit 786b01a8c1db
> ("cleanup regulator supply definitions in mach-omap2") from Linus' tree
> and commit 75ccf268d504 ("[media] OMAP3: RX-51: define vdds_csib
> regulator supply") from the v4l-dvb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.  I am sure
> Linus' will cope with this merge fixup as well, so you do not need to
> rebase/merge to his current tree before sending a pull request.

Thanks!

Yeah, I prefer to base it at vanilla 3.0, instead of basing into a
random point of the Linus tree. I should be submitting the patches
tomorrow to Linus, after giving people some time to do some random
builds with -next.

Mauro


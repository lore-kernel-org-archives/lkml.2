Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0H3JcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:32:10 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43268 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab0H3JcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:32:08 -0400
Date: Mon, 30 Aug 2010 11:32:06 +0200
From: Florian Mickler <florian@mickler.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.kernel-testers
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16393] kernel BUG at fs/block_dev.c:765!
Message-ID: <20100830113206.5f24a4c1@schatten.dmk.lab>
In-Reply-To: <20100830005604.GA1573@arch.trippelsdorf.de>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.u4C.yeueMB@chimera>
	<20100830005604.GA1573@arch.trippelsdorf.de>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 02:56:04 +0200
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On Mon, Aug 30, 2010 at 01:13:29AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16393
> > Subject		: kernel BUG at fs/block_dev.c:765!
> > Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
> > Date		: 2010-07-14 13:52 (47 days old)
> > Message-ID	: <20100714135217.GA1797@arch.tripp.de>
> > References	: http://marc.info/?l=linux-kernel&m=127911564213748&w=2
> > 
> 
> This bug is already fixed by:
> e75aa85892b2ee78c79edac720868cbef16e62eb
> 
> Please close this entry.
> Thanks.
> 

Closed. 

Thx,
Flo

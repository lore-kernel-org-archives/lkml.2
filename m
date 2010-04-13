Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0DMNPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:15:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42755 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab0DMNPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:15:21 -0400
Date: Tue, 13 Apr 2010 09:06:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-kernel@vger.kernel.org,
       Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] libertas/sdio: 8686: set ECSI bit for 1-bit transfers
Message-ID: <20100413130653.GA6331@tuxdriver.com>
References: <1270521759.24724.6.camel@localhost.localdomain> <1270543964-18130-1-git-send-email-daniel@caiaq.de> <1270570054.2969.3.camel@localhost.localdomain> <20100413102954.GH30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413102954.GH30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 12:29:54PM +0200, Daniel Mack wrote:
> On Tue, Apr 06, 2010 at 09:07:34AM -0700, Dan Williams wrote:
> > On Tue, 2010-04-06 at 10:52 +0200, Daniel Mack wrote:
> > > When operating in 1-bit mode, SDAT1 is used as dedicated interrupt line.
> > > However, the 8686 will only drive this line when the ECSI bit is set in
> > > the CCCR_IF register.
> > > 
> > > Thanks to Alagu Sankar for pointing me in the right direction.
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Cc: Alagu Sankar <alagusankar@embwise.com>
> > > Cc: Volker Ernst <volker.ernst@txtr.com>
> > > Cc: Dan Williams <dcbw@redhat.com>
> > > Cc: John W. Linville <linville@tuxdriver.com>
> > > Cc: Holger Schurig <hs4233@mail.mn-solutions.de>
> > > Cc: Bing Zhao <bzhao@marvell.com>
> > > Cc: libertas-dev@lists.infradead.org
> > > Cc: linux-wireless@vger.kernel.org
> > > Cc: linux-mmc@vger.kernel.org
> > 
> > Acked-by: Dan Williams <dcbw@redhat.com>
> 
> Was this picked by anyone?
> Just asking because I didn't see it in the wireless-2.6.git yet.

It is in wireless-next-2.6, queued for 2.6.35.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

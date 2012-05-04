Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab2EDWCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:02:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53542 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2EDWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:02:48 -0400
Date: Fri, 4 May 2012 23:02:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers: Probable misuses of ||
Message-ID: <20120504220241.GA6279@sirena.org.uk>
References: <1333580415.23520.29.camel@joe2Laptop>
 <1336168477.11505.6.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336168477.11505.6.camel@joe2Laptop>
X-Cookie: The bug stops here.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 02:54:37PM -0700, Joe Perches wrote:
> On Wed, 2012-04-04 at 16:00 -0700, Joe Perches wrote:

> > drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> > drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> > drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))

> It's been a month.

> Do you maintainers not care
> about these obvious defects?

It'd probably help if you were to supply more analysis as to what the
issues you think you're seeing are - in the cases quoted above
(especially the last one) there's no obvious bug without further
analysis.

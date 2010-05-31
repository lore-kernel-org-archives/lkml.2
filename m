Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0EaW1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:27:46 -0400
Received: from www.tglx.de ([62.245.132.106]:56013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab0EaW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:27:44 -0400
Date: Tue, 1 Jun 2010 00:27:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <201006010024.00032.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1006010023220.2933@localhost.localdomain>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <1275149418.4503.128.camel@mulgrave.site> <alpine.LFD.2.00.1005312250050.2933@localhost.localdomain> <201006010024.00032.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Rafael J. Wysocki wrote:
> On Monday 31 May 2010, Thomas Gleixner wrote:
> > So that allows to use the same mechanism for more than the android
> > sledge hammer approach and confines the controversial use cases into
> > android specific files without adding a hard to maintain user space
> > interface which would prevent or at least make it hard to do some of
> > the above mentioned things which we want to see implemented.
> 
> I generally agree.
> 
> I think the Alan Stern's recent proposal goes along these lines, but it has
> the advantage of being a bit more specific. ;-)

Yes, Alan Stern's proposal is going into that direction and I'm not
opposed. Just wanted to get the overall picture straight for James :)

Thanks,

	tglx

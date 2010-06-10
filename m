Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab0FJPsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:48:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0FJPsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:48:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Organization: SiSK
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
Date: Thu, 10 Jun 2010 17:46:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20100603193045.GA7188@elte.hu> <201006101059.44411.rjw@sisk.pl> <20100610135714.GA27848@sirena.org.uk>
In-Reply-To: <20100610135714.GA27848@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101746.47035.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 10, 2010, Mark Brown wrote:
> On Thu, Jun 10, 2010 at 10:59:43AM +0200, Rafael J. Wysocki wrote:
> 
> > So, for a phone-like system, where you'd generally want to simplify user space,
> > having a "power manager" in the kernel seems to make sense to me.
> 
> I'm not clear where this requirement to simplify user space specifically
> for phones comes from

This isn't a requirement, but something that IMO is reasonable.

> - phones do have pretty substantial software stacks that aren't that far away
> to PCs.

That doesn't seem to be relevant here.

Rafael

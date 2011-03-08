Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1CHVJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:09:24 -0500
Received: from www.tglx.de ([62.245.132.106]:48199 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab1CHVJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:09:21 -0500
Date: Tue, 8 Mar 2011 22:08:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Ivan Djelic <ivan.djelic@parrot.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC v2 1/3] Shared BCH ECC library
In-Reply-To: <1299587945.2754.32.camel@localhost>
Message-ID: <alpine.LFD.2.00.1103082206270.2787@localhost6.localdomain6>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>  <20110308111548.GA6628@parrot.com> <1299587945.2754.32.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011, Artem Bityutskiy wrote:

> On Tue, 2011-03-08 at 12:15 +0100, Ivan Djelic wrote:
> > On Mon, Feb 07, 2011 at 02:09:30PM +0000, Ivan Djelic wrote:
> > > Hello,
> > > 
> > > The first patch of this series contains a new generic BCH ECC library.
> > 
> > Hi,
> > 
> > It has been a month since this patch was posted, and I did not receive any
> > comment/review yet.
> 
> I can add it to my l2 tree and may be dwmw2 can merge it then. But could
> you please re-send a version with better Kconfig help messages?

I had a quick look. The code looks pretty clean and well documented,
though I did not dig into the details. There are a few comments
"lifted from ...", I hope the code which is copied does not cause any
license issues.

Thanks,

	tglx

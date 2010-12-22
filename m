Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0LVPXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:23:13 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:57127 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752865Ab0LVPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:23:12 -0500
Date: Wed, 22 Dec 2010 10:23:09 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH 0/7] BKL removal follow-up
Message-ID: <20101222152309.GA30670@elliptictech.com>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
 <AANLkTi=qvOHwgsbaCO6_Eu2Uik7MP5=C64+WW8R-RR8B@mail.gmail.com>
 <20101122151723.GA8732@elliptictech.com>
 <201012212354.06895.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012212354.06895.arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-21 23:54 +0100, Arnd Bergmann wrote:
> On Monday 22 November 2010 16:17:23 Nick Bowler wrote:
> > On 2010-11-21 09:45 -0800, Linus Torvalds wrote:
> > > Yes, I'd be ok with UDF doing a "select BKL" along with a "default n"
> > > for BKL itself.
> > > 
> > > I think UDF currently is the only sane reason to have BKL enabled any
> > > more, and yes, it would probably make it easier to configure things.
> > 
> > UFS (which I use) also relies on BKL.
> 
> Would you mind running a kernel with this patch and lockdep enabled then?

I will definitely try it, but I probably won't get around to it before
the new year.

Thanks,

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

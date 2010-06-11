Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268Ab0FKNCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:02:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49886 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756142Ab0FKNCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:02:39 -0400
Date: Fri, 11 Jun 2010 14:02:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: [PATCH] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100611130236.GA4650@rakim.wolfsonmicro.main>
References: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com>
 <20100611105823.GA17546@rakim.wolfsonmicro.main>
 <007201cb0965$542b6cb0$fc824610$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007201cb0965$542b6cb0$fc824610$%szyprowski@samsung.com>
X-Cookie: Don't hit the keys so hard, it hurts.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 02:55:07PM +0200, Marek Szyprowski wrote:
> On Friday, June 11, 2010 12:58 PM Mark Brown wrote:

> > A few things in the code make it look like the driver should be using
> > the MFD framework - there's references in here for things like a battery
> > charger which should be being supported via the power subsystem, for
> > example.

> You are right, this chip is really complicated and should work with more
> than one kernel subsystem. However in this initial version of the driver
> we tried to make it as simple as possible. It can be converted to MFD
> framework later, but if you want we can prepare this driver as MFD from
> the beginning.

It makes life a lot easier to start off with the MFD, even if you only
add a single function driver initially.  Otherwise you end up with cross
tree hassle trying to deal with the transiton later on.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab1D1KkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:40:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45295 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759221Ab1D1KkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:40:13 -0400
Date: Thu, 28 Apr 2011 11:40:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sakari Ailus <sakari.ailus@nokia.com>
Cc: kalle.jokiniemi@nokia.com, lrg@slimlogic.co.uk, mchehab@infradead.org,
        svarbatov@mm-sol.com, saaguirre@ti.com, grosikopulos@mm-sol.com,
        vimarsh.zutshi@nokia.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Regulator state after regulator_get
Message-ID: <20110428104021.GD14494@opensource.wolfsonmicro.com>
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
 <4DB9348D.7000501@nokia.com>
 <9D0D31AA57AAF5499AFDC63D6472631B09C7BE@008-AM1MPN1-036.mgdnok.nokia.com>
 <20110428102009.GB14494@opensource.wolfsonmicro.com>
 <4DB94122.9010203@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB94122.9010203@nokia.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 01:27:46PM +0300, Sakari Ailus wrote:
> Mark Brown wrote:

> > I'm not sure what "supply_nasty" would mean?  This also doesn't seem
> > like something that we can set up per supply - it's going to affect the
> > whole regulator state, it's not something that only affects a single
> > supply.

> supply_nasty() would be used to define a regulator which is enabled by
> the boot loader when it shouldn't be, which is the actual problem.

That's *really* not a clear name.

> How should this regulator be turned off in the boot by the kernel?

Have you read my previous mail where I described the existing support
for doing this when we have a full set of information on the regualtors
in the systems?

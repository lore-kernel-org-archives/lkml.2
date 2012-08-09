Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2HIKrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:47:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52759 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837Ab2HIKrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:47:49 -0400
Date: Thu, 9 Aug 2012 11:47:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Cyril Chemparathy <cyril@ti.com>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] regulator: Update comment for set_current_limit
 callback of struct regulator_ops
Message-ID: <20120809104747.GK24328@opensource.wolfsonmicro.com>
References: <1344428238.3199.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344428238.3199.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 08:17:18PM +0800, Axel Lin wrote:
> The regulators should be tending to the maximum in the available range and
> consumers should specify the widest range possible.

Applied all except 2 and 3.  Those are for actual current regulators
which are a bit odd here - I'm not really sure they should be in the
regulator API at all but their function is very different to the current
limits that are normally being specified.

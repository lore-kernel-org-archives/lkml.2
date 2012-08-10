Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2HJM3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:29:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60970 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044Ab2HJM3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:29:06 -0400
Date: Fri, 10 Aug 2012 13:29:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] regulator: core: Add checking n_voltages if using
 list_voltage() to read voltage regulators
Message-ID: <20120810122903.GJ24328@opensource.wolfsonmicro.com>
References: <1344562353.2996.1.camel@phoenix>
 <20120810100547.GG24328@opensource.wolfsonmicro.com>
 <CAF+7xWmmuf0bSROpvd+2RW-XFV=_nf6Zu3KC9-hW2rWDwVwncg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWmmuf0bSROpvd+2RW-XFV=_nf6Zu3KC9-hW2rWDwVwncg@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 08:27:32PM +0800, Axel Lin wrote:
> 2012/8/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > We should be failing to register these regulators in the first place, or
> > at least complaining extremely loudly about them.

> Oh. My original intention is to prevent using list_voltage() to read
> voltage regulators for the case "n_voltages > 1" in case of both get_voltage
> and get_voltage_sel are not implemented.

Yes, I see the intention - what I'm saying is that a regulator like that
makes no sense in the first place.

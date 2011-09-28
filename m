Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1I1JD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:03:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33463 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1I1JD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:03:56 -0400
Date: Wed, 28 Sep 2011 10:03:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add gpio based voltage switching regulator
Message-ID: <20110928090353.GA3279@opensource.wolfsonmicro.com>
References: <201109260852.19859.heiko@sntech.de>
 <20110926125155.GH2946@opensource.wolfsonmicro.com>
 <201109281002.57101.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201109281002.57101.heiko@sntech.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:02:54AM +0200, Heiko Stübner wrote:
> 	.switch_gpios = {
> 		GPIO1, /* bit 0 in matrix */
> 		GPIO2, /* bit 1 in matrix */
> 	},
> 	.nr_switch_gpios = 2,

This seems like a good plan.

> > This needs a better name.
> "gpio-regulator"?

> I'm quite open to suggestions :-)

That would be better, yes.

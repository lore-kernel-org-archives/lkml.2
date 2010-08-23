Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab0HWKBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:01:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34727 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751747Ab0HWKBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:01:31 -0400
Date: Mon, 23 Aug 2010 11:01:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regulator: max8998 - set max8998->num_regulators
Message-ID: <20100823100128.GE6061@rakim.wolfsonmicro.main>
References: <1282462009.2989.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282462009.2989.2.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 03:26:49PM +0800, Axel Lin wrote:
> Set max8998->num_regulators = pdata->num_regulators,
> otherwise it's default value is 0.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

With a change like this it's good to note why things worked prior to the
change - my first thought was that it might be better to loose the
driver data copy entirely if we were fine with it being set to zero.

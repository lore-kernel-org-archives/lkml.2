Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2HFObT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:31:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49035 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399Ab2HFObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:31:17 -0400
Date: Mon, 6 Aug 2012 15:31:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Add intermediate cast to uintptr_t
 before casting to pointer
Message-ID: <20120806143115.GL16861@opensource.wolfsonmicro.com>
References: <1343605633.11323.1.camel@phoenix>
 <20120730153309.GK4468@opensource.wolfsonmicro.com>
 <1343701316.7557.1.camel@phoenix>
 <20120731154153.GI4468@opensource.wolfsonmicro.com>
 <1343750888.5463.5.camel@phoenix>
 <20120802180051.GI4537@opensource.wolfsonmicro.com>
 <CAF+7xWmvnJ5LCz6GW+MVb8eExhmfVM=CSG_v==iAJ+2Kv=jmaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWmvnJ5LCz6GW+MVb8eExhmfVM=CSG_v==iAJ+2Kv=jmaw@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 12:10:33AM +0800, Axel Lin wrote:

> Either is ok to me.
> But the double case looks better to me because the intention is clear.
> It seems uintptr_t is less commonly used in drivers code.
> Maybe just use (void *)(unsigned long)best_val is better in readability.

Two casts just looks terrible to me to be honest, it'll set off alarm
bells any time I glance at the code just from the visual pattern.

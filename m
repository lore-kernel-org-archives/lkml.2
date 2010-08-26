Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0HZJxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:53:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:40098 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab0HZJxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:53:40 -0400
Date: Thu, 26 Aug 2010 18:51:48 +0900
To: g.liakhovetski@gmx.de
Cc: fujita.tomonori@lab.ntt.co.jp, mitov@issp.bas.bg,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        philippe.retornaz@epfl.ch, gregkh@suse.de, jkrzyszt@tis.icnet.pl
Subject: Re: [RFC][PATCH] add
 dma_reserve_coherent_memory()/dma_free_reserved_memory() API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.1008261140390.14167@axis700.grange>
References: <Pine.LNX.4.64.1008261100150.14167@axis700.grange>
	<20100826182915S.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.1008261140390.14167@axis700.grange>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100826185102I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 26 Aug 2010 18:51:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 11:45:58 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Thu, 26 Aug 2010, FUJITA Tomonori wrote:
> 
> > Why can't you revert a commit that causes the regression?
> 
> See this reply, and the complete thread too.
> 
> http://marc.info/?l=linux-sh&m=128130485208262&w=2
> 
> > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > responsible for the regression. And the patchset even exnteds the
> > definition of the DMA API (dma_declare_coherent_memory). Such change
> > shouldn't applied after rc1. I think that DMA-API.txt says that
> > dma_declare_coherent_memory() handles coherent memory for a particular
> > device. It's not for the API that reserves coherent memory that can be
> > used for any device for a single device.
> 
> Anyway, we need a way to fix the regression.

Needs to find a different way.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0JNPYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:24:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:53693 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0JNPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:24:20 -0400
Date: Fri, 15 Oct 2010 00:24:05 +0900
To: felipe.contreras@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTin-8mjL_B8g9cPoviQU0FUaEyb_v5_Fm4kbSweA@mail.gmail.com>
References: <87sk0a1sq0.fsf@basil.nowhere.org>
	<20101014160217N.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTin-8mjL_B8g9cPoviQU0FUaEyb_v5_Fm4kbSweA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101015001904I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 Oct 2010 00:24:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 15:09:13 +0300
Felipe Contreras <felipe.contreras@gmail.com> wrote:

> > As already pointed out, some embeded drivers need physcailly
> > contignous memory. Currenlty, they use hacky tricks (e.g. playing with
> > the boot memory allocators). There are several proposals for this like
> > adding a new kernel memory allocator (from samsung).
> >
> > It's ideal if the memory allocator can handle this, I think.
> 
> Not only contiguous, but sometimes also coherent.

Can you give the list of such drivers?

Anyway, in general cases, the page allocator needs to allocate large
contignous memory if we want dma_alloc_coherent to return large
contignous coherent memory.

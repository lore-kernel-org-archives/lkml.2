Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0JNPKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:10:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:45351 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab0JNPKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:10:12 -0400
Date: Fri, 15 Oct 2010 00:09:47 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        minchan.kim@gmail.com
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101014125519.GB13414@basil.fritz.box>
References: <20101014072421.GA13414@basil.fritz.box>
	<20101014173103U.fujita.tomonori@lab.ntt.co.jp>
	<20101014125519.GB13414@basil.fritz.box>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101015000416N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 Oct 2010 00:09:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 14:55:19 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > I think that at least one mainline driver in arm uses such trick but I
> > can't recall the name. Better to ask on the arm mainling list. Also I
> > heard that the are some out-of-tree patches about this.
> 
> I'm sure there are out of tree patches for lots of things,
> but at least in terms of merging mainline functionality
> use cases merged in the mainline tree are required.

I think that we already have drivers that need such feature in
mainline. They keep out-of-tree patches that give continuous memory to
these drivers reliably.

Anyway, Felipe pointed out one user. I also think that
drivers/media/video/videobuf-dma-contig.c also was already mentioned,
needs such feature.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0JNHHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:07:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:50272 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab0JNHHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:07:45 -0400
Date: Thu, 14 Oct 2010 16:07:12 +0900
To: andi@firstfloor.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <87sk0a1sq0.fsf@basil.nowhere.org>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<87sk0a1sq0.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101014160217N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 14 Oct 2010 16:07:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 09:01:43 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> >
> > What this wants to do: 
> >   allocates a contiguous chunk of pages larger than MAX_ORDER.
> >   for device drivers (camera? etc..)
> 
> I think to really move forward you need a concrete use case
> actually implemented in tree.

As already pointed out, some embeded drivers need physcailly
contignous memory. Currenlty, they use hacky tricks (e.g. playing with
the boot memory allocators). There are several proposals for this like
adding a new kernel memory allocator (from samsung).

It's ideal if the memory allocator can handle this, I think.

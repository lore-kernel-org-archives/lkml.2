Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0JNHYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:24:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60959 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JNHY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:24:29 -0400
Date: Thu, 14 Oct 2010 09:24:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
Message-ID: <20101014072421.GA13414@basil.fritz.box>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
 <87sk0a1sq0.fsf@basil.nowhere.org>
 <20101014160217N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014160217N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 04:07:12PM +0900, FUJITA Tomonori wrote:
> On Wed, 13 Oct 2010 09:01:43 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > >
> > > What this wants to do: 
> > >   allocates a contiguous chunk of pages larger than MAX_ORDER.
> > >   for device drivers (camera? etc..)
> > 
> > I think to really move forward you need a concrete use case
> > actually implemented in tree.
> 
> As already pointed out, some embeded drivers need physcailly
> contignous memory. Currenlty, they use hacky tricks (e.g. playing with
> the boot memory allocators). There are several proposals for this like

Are any of those in mainline? 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

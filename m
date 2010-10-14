Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0JNIgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:36:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:46943 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab0JNIgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:36:44 -0400
Date: Thu, 14 Oct 2010 17:36:28 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        minchan.kim@gmail.com
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101014072421.GA13414@basil.fritz.box>
References: <87sk0a1sq0.fsf@basil.nowhere.org>
	<20101014160217N.fujita.tomonori@lab.ntt.co.jp>
	<20101014072421.GA13414@basil.fritz.box>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101014173103U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 14 Oct 2010 17:36:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 09:24:21 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Oct 14, 2010 at 04:07:12PM +0900, FUJITA Tomonori wrote:
> > On Wed, 13 Oct 2010 09:01:43 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > > >
> > > > What this wants to do: 
> > > >   allocates a contiguous chunk of pages larger than MAX_ORDER.
> > > >   for device drivers (camera? etc..)
> > > 
> > > I think to really move forward you need a concrete use case
> > > actually implemented in tree.
> > 
> > As already pointed out, some embeded drivers need physcailly
> > contignous memory. Currenlty, they use hacky tricks (e.g. playing with
> > the boot memory allocators). There are several proposals for this like
> 
> Are any of those in mainline? 

The tricks or the proposals?

I think that at least one mainline driver in arm uses such trick but I
can't recall the name. Better to ask on the arm mainling list. Also I
heard that the are some out-of-tree patches about this.


I think that any such proposal hasn't merged yet. If you are looking
for such examples, here's one:

http://lwn.net/Articles/401107/

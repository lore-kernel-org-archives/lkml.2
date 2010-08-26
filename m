Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0HZEOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:14:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61557 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0HZEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F9CaaNcVrxdB7r/fr+WnTFO7+i7O+aSDERBrF3I3KGDqkDOVreYKRJfA/GWG4PFtjT
         coAgNvDzf/4wrO5YE61T7Rig+1xlkWVTb1qv/mSCZL/28qccBJC1fYuV1y7aU+M7Ffj5
         NiDBboAardMWBLsxAErHvuWeFWyy+ucsVaD4o=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=T1y+sQuqVTYgOkYvqrxdYB1bZmCpKafN5jPqi@mail.gmail.com>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	<1282310110.2605.976.camel@laptop>
	<20100825155814.25c783c7.akpm@linux-foundation.org>
	<20100826095857.5b821d7f.kamezawa.hiroyu@jp.fujitsu.com>
	<op.vh0wektv7p4s8u@localhost>
	<20100826115017.04f6f707.kamezawa.hiroyu@jp.fujitsu.com>
	<20100826124434.6089630d.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=T1y+sQuqVTYgOkYvqrxdYB1bZmCpKafN5jPqi@mail.gmail.com>
Date: Thu, 26 Aug 2010 13:14:07 +0900
Message-ID: <AANLkTimatyb6cONqH319-xYmXTBb_jQuTLCmU_M6jYPa@mail.gmail.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 1:06 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Thu, Aug 26, 2010 at 12:44 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Thu, 26 Aug 2010 11:50:17 +0900
>> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>>> 128MB...too big ? But it's depend on config.
>>>
>>> IBM's ppc guys used 16MB section, and recently, a new interface to shrink
>>> the number of /sys files are added, maybe usable.
>>>
>>> Something good with this approach will be you can create "cma" memory
>>> before installing driver.
>>>
>>> But yes, complicated and need some works.
>>>
>> Ah, I need to clarify what I want to say.
>>
>> With compaction, it's helpful, but you can't get contiguous memory larger
>> than MAX_ORDER, I think. To get memory larger than MAX_ORDER on demand,
>> memory hot-plug code has almost all necessary things.
>
> True. Doesn't patch's idea of Christoph helps this ?
> http://lwn.net/Articles/200699/

Of course, It itself can't meet our requirement but idea of range
allocation seem to be good.
I think it can be start point.

>
> --
> Kind regards,
> Minchan Kim
>



-- 
Kind regards,
Minchan Kim

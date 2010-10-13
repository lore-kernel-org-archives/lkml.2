Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0JMHBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:01:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59989 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0JMHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:01:49 -0400
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 13 Oct 2010 09:01:43 +0200
In-Reply-To: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Wed, 13 Oct 2010 12:15:27 +0900")
Message-ID: <87sk0a1sq0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
>
> What this wants to do: 
>   allocates a contiguous chunk of pages larger than MAX_ORDER.
>   for device drivers (camera? etc..)

I think to really move forward you need a concrete use case
actually implemented in tree.

>   My intention is not for allocating HUGEPAGE(> MAX_ORDER).

I still believe using this for 1GB pages would be one of the more
interesting use cases.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

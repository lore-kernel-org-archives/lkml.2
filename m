Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2AQN3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:29:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49413 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2AQN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:29:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120117131601.GB14907@tiehlicka.suse.cz>
References: <CAJd=RBBdDriMhfetM2AWGzgxiJ1DDs-W4Ff9_1Z8DUgbyQmSkA@mail.gmail.com>
	<20120117131601.GB14907@tiehlicka.suse.cz>
Date: Tue, 17 Jan 2012 21:29:52 +0800
Message-ID: <CAJd=RBBcL5RuW1wC_Yh=gy2Ja8wqJ6jhf28zNi1n6MJ=+0=m2Q@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: remove checking reclaim order in soft limit reclaim
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:16 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Hi,
>
> On Tue 17-01-12 20:47:59, Hillf Danton wrote:
>> If async order-O reclaim expected here, it is settled down when setting up scan
>> control, with scan priority hacked to be zero. Other than that, deny of reclaim
>> should be removed.
>
> Maybe I have misunderstood you but this is not right. The check is to
> protect from the _global_ reclaim with order > 0 when we prevent from
> memcg soft reclaim.
>
need to bear mm hog in this way?

Thanks
Hillf

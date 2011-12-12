Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1LLMsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:48:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59442 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1LLMsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:48:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1112111520510.2297@eggly>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
	<alpine.LSU.2.00.1112111520510.2297@eggly>
Date: Mon, 12 Dec 2011 20:48:02 +0800
Message-ID: <CAJd=RBBKsRYq3Y4gaGJMHM3kMJUH_jggf3pFVJK+noD-vpCRCg@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: keep root group unchanged if fail to create new
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>, David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hugh

On Mon, Dec 12, 2011 at 7:39 AM, Hugh Dickins <hughd@google.com> wrote:
> On Sun, 11 Dec 2011, Hillf Danton wrote:
>
>> If the request is not to create root group and we fail to meet it,
>> we'd leave the root unchanged.
>
> I didn't understand that at first: please say "we should" rather
> than "we'd", which I take to be an abbreviation for "we would".
>

Thanks for correcting me.

>
> I wonder what was going through the author's mind when he wrote it
> that way?  I wonder if it's one of those bugs that creeps in when
> you start from a perfectly functional patch, then make refinements
> to suit feedback from reviewers.
>

Actually no such a perfectly functional patch, but I also wonder if
you are likely to post and/or share your current todo list if any,
then many could learn the right direction, and in turn you comment
and pull acceptable works in that direction, like Linus.

Hillf

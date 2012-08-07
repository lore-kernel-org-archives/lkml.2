Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2HGMNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:13:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35081 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2HGMNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1208061831490.1509@eggly.anvils>
References: <CAJd=RBB2Hsqnn58idvs5azMonRhk0A6EOKZ=tTskRngGk=XCOw@mail.gmail.com>
	<alpine.LSU.2.00.1208061831490.1509@eggly.anvils>
Date: Tue, 7 Aug 2012 20:13:22 +0800
Message-ID: <CAJd=RBA-Z3W=GDR0WO6k5zqPwUG28Tp0q+aEg14zu86gZr-+TQ@mail.gmail.com>
Subject: Re: [RFC patch] mmap: permute find_vma with find_vma_prev
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:08 AM, Hugh Dickins <hughd@google.com> wrote:
> And rarely is its prev search actually required.  Whereas there are lots
> of users of find_vma(), who want it to be as quick as possible: it should
> not be burdened with almost-never-needed extras.

Got, thanks.

> I don't know what you're referring to: what happened to LKML?

For a couple of days it has been not updated, just an advertisement at
https://lkml.org/lkml/2012/8/7/ and stale content at
https://lkml.org/lkml/last100/

Hillf

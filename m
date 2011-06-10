Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab1FJWYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:24:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758103Ab1FJWYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Jun 2011 15:24:11 -0700
Message-ID: <BANLkTimm_nD77BV8CLSGF95+E7JP1sv6ig@mail.gmail.com>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 3:04 AM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> Please be more polite to other people. After a197b59ae6 all allocations
> with GFP_DMA set on nodes without ZONE_DMA fail nearly silently (only
> one warning during bootup is emited, no matter how many things fail).
> This is a very crude change on behaviour. To be more civil, instead of
> failing emit noisy warnings each time smbd. tries to allocate a GFP_DMA
> memory on non-ZONE_DMA node.

The whole thing already got reverted in commit 1fa7b6a29c613.

                   Linus

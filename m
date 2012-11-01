Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab2KAU0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:26:14 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:38648 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415Ab2KAU0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:26:12 -0400
Date: Thu, 1 Nov 2012 20:26:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Minchan Kim <minchan@kernel.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] Support volatile range for anon vma
In-Reply-To: <20121026005851.GD15767@bbox>
Message-ID: <0000013abda6fc7d-6cfbef1e-bc7d-4f4f-bb38-221729e8c9f9-000000@email.amazonses.com>
References: <1351133820-14096-1-git-send-email-minchan@kernel.org> <0000013a9881a86c-c0fb5823-b6e7-4bea-8707-f6b8eddae14d-000000@email.amazonses.com> <20121026005851.GD15767@bbox>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, Minchan Kim wrote:

> I guess it would improve system performance very well.
> But as I wrote down in description, downside of the patch is that we have to
> age anon lru although we don't have swap. But gain via the patch is bigger than
> loss via aging of anon lru when memory pressure happens. I don't see other downside
> other than it. What do you think about it?
> (I didn't implement anon lru aging in case of no-swap but it's trivial
> once we decide)


I am a bit confused like some of the others as to why this patch is
necessary since we already have DONT_NEED.

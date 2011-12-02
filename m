Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1LBCAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:00:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62106 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1LBCAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:00:12 -0500
Subject: Re: [PATCH] mm: incorrect overflow check in shrink_slab()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20111201125457.fdf79489.akpm@linux-foundation.org>
Date: Thu, 1 Dec 2011 21:00:08 -0500
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <829F10B1-D23B-4CCD-B73F-38501B900DDA@gmail.com>
References: <0D9D9F79-204D-4460-8CE7-A583C5C38A1E@gmail.com> <20111201183202.2e5bd872.kamezawa.hiroyu@jp.fujitsu.com> <20111201125457.fdf79489.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 1, 2011, at 3:54 PM, Andrew Morton wrote:
> Konstantin Khlebnikov's "vmscan: fix initial shrinker size handling"
> does change it to `long'.  That patch is in -mm and linux-next and is
> queued for 3.3.  It was queued for 3.2 but didn't make it due to some
> me/Dave Chinner confusion.

I see.  Cool.  Thanks for the pointer.

- xi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1LAJ5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:57:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59993 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1LAJ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:57:14 -0500
Subject: Re: [PATCH] mm: incorrect overflow check in shrink_slab()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20111201183202.2e5bd872.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 1 Dec 2011 04:57:10 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C71EB769-AD4F-4860-BC1D-0BEC268894AC@gmail.com>
References: <0D9D9F79-204D-4460-8CE7-A583C5C38A1E@gmail.com> <20111201183202.2e5bd872.kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 1, 2011, at 4:32 AM, KAMEZAWA Hiroyuki wrote:
> Nice catch but.... the 'total_scan" shouldn't be long ?
> Rather than type casting ?

Could be..  I am just trying to avoid signed integer overflow like
"total_scan += delta" in that case, which is undefined, even though
the kernel is compiled with -fno-strict-overflow.

- xi


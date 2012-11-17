Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2KQVzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:55:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2KQVzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:55:00 -0500
Date: Sat, 17 Nov 2012 19:54:35 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v12 4/7] mm: introduce compaction and migration for
 ballooned pages
Message-ID: <20121117215434.GA23879@x61.redhat.com>
References: <cover.1352656285.git.aquini@redhat.com>
 <6602296b38c073a5c6faa13ddbc74ceb1eceb2dd.1352656285.git.aquini@redhat.com>
 <50A7D0FA.2080709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A7D0FA.2080709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 01:01:30PM -0500, Sasha Levin wrote:
> 
> I'm getting the following while fuzzing using trinity inside a KVM tools guest,
> on latest -next:
> 
> [ 1642.783728] BUG: unable to handle kernel NULL pointer dereference at 0000000000000194
> [ 1642.785083] IP: [<ffffffff8122b354>] isolate_migratepages_range+0x344/0x7b0
> 
> My guess is that we see those because of a race during the check in
> isolate_migratepages_range().
> 
> 
> Thanks,
> Sasha

Sasha, could you share your .config and steps you did used with trinity? So I
can attempt to reproduce this issue you reported.

Thanks, 
Rafael

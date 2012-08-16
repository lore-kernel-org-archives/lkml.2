Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab2HPOw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:52:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab2HPOwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:52:55 -0400
Date: Thu, 16 Aug 2012 16:52:53 +0200
From: Jan Kara <jack@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [MMTests] dbench4 async on ext3
Message-ID: <20120816145253.GB9057@quack.suse.cz>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120723212146.GG9222@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723212146.GG9222@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23-07-12 22:21:46, Mel Gorman wrote:
> Configuration:	global-dhp__io-dbench4-async-ext3
> Result: 	http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-dbench4-async-ext3
> Benchmarks:	dbench4
> 
> Summary
> =======
> 
> In general there was a massive drop in throughput after 3.0. Very broadly
> speaking it looks like the Read operation got faster but at the cost of
> a big regression in the Flush operation.
  This looks bad. Also quickly looking into changelogs I don't see any
change which could cause this. I'll try to reproduce this and track it
down.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

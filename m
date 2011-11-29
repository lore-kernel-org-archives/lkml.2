Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1K2R5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:57:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1K2R5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:57:46 -0500
Date: Tue, 29 Nov 2011 18:57:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] readahead: record readahead patterns
Message-ID: <20111129175743.GP24062@one.firstfloor.org>
References: <20111129130900.628549879@intel.com> <20111129131456.278516066@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129131456.278516066@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:09:03PM +0800, Wu Fengguang wrote:
> Record the readahead pattern in ra->pattern and extend the ra_submit()
> parameters, to be used by the next readahead tracing/stats patches.

I like this, could it be exported it a bit more formally in /proc for 
each file descriptor?

I could imagine a monitoring tool that you run on a process that
tells you what pattern state the various file descriptors are in and how
large the window is. That would be similar to the tools for
monitoring network connections, which are extremly useful 
in practice.

-Andi


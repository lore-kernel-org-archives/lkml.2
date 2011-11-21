Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1KUXc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:32:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37104 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab1KUXc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:32:56 -0500
Date: Tue, 22 Nov 2011 00:32:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/8] readahead: add /debug/readahead/stats
Message-ID: <20111121233255.GF24062@one.firstfloor.org>
References: <20111121091819.394895091@intel.com> <20111121093846.636765408@intel.com> <20111121152958.e4fd76d4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121152958.e4fd76d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I may be wrong, but I don't think the CPU cost of this code matters a
> lot.  People will rarely turn it on and disk IO is a lot slower than
> CPU actions and it's waaaaaaay more important to get high-quality info
> about readahead than it is to squeeze out a few CPU cycles.

In its current form it would cache line bounce, which tends to be 
extremly slow. But the solution is probably to make it per CPU.

-Andi


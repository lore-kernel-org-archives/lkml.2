Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1KUOSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:18:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1KUOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:18:05 -0500
Date: Mon, 21 Nov 2011 15:17:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/8] readahead: add /debug/readahead/stats
Message-ID: <20111121141759.GE24062@one.firstfloor.org>
References: <20111121091819.394895091@intel.com> <20111121093846.636765408@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121093846.636765408@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static unsigned long ra_stats[RA_PATTERN_MAX][RA_ACCOUNT_MAX];

Why not make it per cpu?  That should get the overhead down, probably
even enough that it can be enabled by default.

BTW I have an older framework to make it really easy to add per
cpu stats counters to debugfs. Will repost, that would simplify
it even more.

-Andi

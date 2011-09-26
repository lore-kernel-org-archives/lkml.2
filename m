Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1IZPbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1IZPbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:31:17 -0400
Message-ID: <4E809ABB.2020807@redhat.com>
Date: Mon, 26 Sep 2011 11:31:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] limit direct reclaim for higher order allocations
References: <20110926095507.34a2c48c@annuminas.surriel.com> <20110926150212.GB11313@suse.de>
In-Reply-To: <20110926150212.GB11313@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 11:02 AM, Mel Gorman wrote:

> I don't have a proper patch prepared but I think it is a mistake for
> reclaim and compaction to be using different logic when deciding
> if action should be taken. Compaction uses compaction_suitable()
> and compaction_deferred() to decide whether it should compact or not
> and reclaim/compaction should share the same logic. I don't have a
> proper patch but the check would look something like;

Mel and I just hashed out the details on IRC.

I'm building a test kernel with the new logic now and will
post an updated patch if everything works as expected.

-- 
All rights reversed

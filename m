Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0DUNVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab0DUNVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:21:50 -0400
Message-ID: <4BCEFBAB.4070403@redhat.com>
Date: Wed, 21 Apr 2010 09:20:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com> <20100419214412.GB5336@cmpxchg.org> <4BCD55DA.2020000@linux.vnet.ibm.com> <20100420153202.GC5336@cmpxchg.org> <4BCDE2F0.3010009@redhat.com> <4BCE7DD1.70900@linux.vnet.ibm.com>
In-Reply-To: <4BCE7DD1.70900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 12:23 AM, Christian Ehrhardt wrote:

> IMHO it is fine to prevent that nightly backup job from not being
> finished when the user arrives at morning because we didn't give him
> some more cache

How on earth would a backup job benefit from cache?

It only accesses each bit of data once, so caching the
to-be-backed-up data is a waste of memory.

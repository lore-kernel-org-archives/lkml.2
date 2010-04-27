Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0D0COO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 22:14:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab0D0CON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 22:14:13 -0400
Message-ID: <4BD64848.9070604@redhat.com>
Date: Mon, 26 Apr 2010 22:13:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>	<1272321478-28481-3-git-send-email-mel@csn.ul.ie>	<4BD63031.6050105@redhat.com> <20100427093136.4de21a47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100427093136.4de21a47.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 08:31 PM, KAMEZAWA Hiroyuki wrote:

>> If you're part way down the list, surely you'll need to
>> unlock multiple anon_vmas here before going to retry?
>>
> vma->anon_vma->lock is released after vma_address().

Doh, never mind.  Too much code in my mind at once...

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

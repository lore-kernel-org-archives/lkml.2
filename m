Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2F1U5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2F1U5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:57:33 -0400
Message-ID: <4FECC51C.6050605@redhat.com>
Date: Thu, 28 Jun 2012 16:57:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jim Schutt <jaschut@sandia.gov>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm v2] mm: have order > 0 compaction start off where
 it left
References: <20120628135520.0c48b066@annuminas.surriel.com> <4FECBC50.2060705@sandia.gov>
In-Reply-To: <4FECBC50.2060705@sandia.gov>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:19 PM, Jim Schutt wrote:
> On 06/28/2012 11:55 AM, Rik van Riel wrote:
>
>> ---
>> v2: implement Mel's suggestions, handling wrap-around etc
>>
>
> So far I've run a total of ~28 TB of data over seventy minutes
> or so through 12 machines running this version of the patch;
> still no hint of trouble, still great performance.
>
> Tested-by: Jim Schutt <jaschut@sandia.gov>

Awesome, thank you very much for analyzing and reporting
the issue, and testing the patch!

Mel? Andrew? :)

-- 
All rights reversed

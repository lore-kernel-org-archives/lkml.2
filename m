Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928Ab2DKSy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:54:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59007 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2DKSyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <4F85BE78.8040205@redhat.com>
References: <1334162298-18942-1-git-send-email-mgorman@suse.de>
 <1334162298-18942-2-git-send-email-mgorman@suse.de> <4F85BE78.8040205@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Apr 2012 14:54:04 -0400
Message-ID: <CAHGf_=rm0m4XZn=BJ8uLnarq9MwSvFbQMW=5ueRzM8ezincKmA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: vmscan: Remove lumpy reclaim
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 1:25 PM, Rik van Riel <riel@redhat.com> wrote:
> On 04/11/2012 12:38 PM, Mel Gorman wrote:
>>
>> Lumpy reclaim had a purpose but in the mind of some, it was to kick
>> the system so hard it trashed. For others the purpose was to complicate
>> vmscan.c. Over time it was giving softer shoes and a nicer attitude but
>> memory compaction needs to step up and replace it so this patch sends
>> lumpy reclaim to the farm.
>>
>> The tracepoint format changes for isolating LRU pages with this patch
>> applied. Furthermore reclaim/compaction can no longer queue dirty pages in
>> pageout() if the underlying BDI is congested. Lumpy reclaim used this
>> logic
>> and reclaim/compaction was using it in error.
>>
>> Signed-off-by: Mel Gorman<mgorman@suse.de>
>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

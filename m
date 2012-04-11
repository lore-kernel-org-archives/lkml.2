Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab2DKTsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:48:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54950 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761128Ab2DKTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <4F85BEE1.1050607@redhat.com>
References: <1334162298-18942-1-git-send-email-mgorman@suse.de>
 <1334162298-18942-4-git-send-email-mgorman@suse.de> <4F85BEE1.1050607@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Apr 2012 15:48:11 -0400
Message-ID: <CAHGf_=r8vBCm7-W1_6K_crbo-9C4zXSxn_u-LqHjYAVLdXieGg@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: vmscan: Remove reclaim_mode_t
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 1:26 PM, Rik van Riel <riel@redhat.com> wrote:
> On 04/11/2012 12:38 PM, Mel Gorman wrote:
>>
>> There is little motiviation for reclaim_mode_t once RECLAIM_MODE_[A]SYNC
>> and lumpy reclaim have been removed. This patch gets rid of reclaim_mode_t
>> as well and improves the documentation about what reclaim/compaction is
>> and when it is triggered.
>>
>> Signed-off-by: Mel Gorman<mgorman@suse.de>
>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

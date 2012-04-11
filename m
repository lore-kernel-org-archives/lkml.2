Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921Ab2DKS43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab2DKS42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:56:28 -0400
Message-ID: <4F85BEE1.1050607@redhat.com>
Date: Wed, 11 Apr 2012 13:26:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: vmscan: Remove reclaim_mode_t
References: <1334162298-18942-1-git-send-email-mgorman@suse.de> <1334162298-18942-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1334162298-18942-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 12:38 PM, Mel Gorman wrote:
> There is little motiviation for reclaim_mode_t once RECLAIM_MODE_[A]SYNC
> and lumpy reclaim have been removed. This patch gets rid of reclaim_mode_t
> as well and improves the documentation about what reclaim/compaction is
> and when it is triggered.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


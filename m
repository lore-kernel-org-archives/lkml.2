Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1FMBeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:34:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35100 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1FMBeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:34:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF5690C.4090000@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 10:34:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, aarcange@redhat.com,
        riel@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH v3 07/10] migration: clean up unmap_and_move
References: <cover.1307455422.git.minchan.kim@gmail.com> <cf5cd5055db22ae301e01294f191bd94b17e7775.1307455422.git.minchan.kim@gmail.com>
In-Reply-To: <cf5cd5055db22ae301e01294f191bd94b17e7775.1307455422.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/07 23:38), Minchan Kim wrote:
> The unmap_and_move is one of big messy functions.
> This patch try to clean up.
> 
> It can help readability and make unmap_and_move_ilru simple.
> unmap_and_move_ilru will be introduced by next patch.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1KKXgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 18:36:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45769 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1KKXgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 18:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111111124005.7371.63176.stgit@zurg>
References: <20110729075837.12274.58405.stgit@localhost6>
	<20111111124005.7371.63176.stgit@zurg>
Date: Sat, 12 Nov 2011 08:36:03 +0900
Message-ID: <CAEwNFnBKiM=0YVYzs=_fbHCac96J_yb+SbnCMpYGFJLLMSCsxg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mm-tracepoint: rename page-free events
From: Minchan Kim <minchan.kim@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:40 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Rename mm_page_free_direct into mm_page_free
> and mm_pagevec_free into mm_page_free_batched
>
> Since v2.6.33-5426-gc475dab kernel trigger mm_page_free_direct for all freed pages,
> not only for directly freed. So, let's name it properly.
> For pages freed via page-list we also trigger mm_page_free_batched event.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

1+ for clear naming but I am not quite sure event name change is
always OK for compatibility of old perf.
At least, we will need to Cced Ingo, I think.


-- 
Kind regards,
Minchan Kim

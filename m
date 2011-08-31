Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1HaLOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:14:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab1HaLN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:13:59 -0400
Date: Wed, 31 Aug 2011 13:13:22 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/3] Correct isolate_mode_t bitwise type
Message-ID: <20110831111322.GA17512@redhat.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 01:37:41AM +0900, Minchan Kim wrote:
> [c1e8b0ae8, mm-change-isolate-mode-from-define-to-bitwise-type]
> made a mistake on the bitwise type.
> 
> This patch corrects it.
> 
> CC: Mel Gorman <mgorman@suse.de>
> CC: Johannes Weiner <jweiner@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>

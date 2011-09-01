Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1IANFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:05:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1IANFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:05:46 -0400
Date: Thu, 1 Sep 2011 14:05:42 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/3] Correct isolate_mode_t bitwise type
Message-ID: <20110901130542.GG14369@suse.de>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <e139175e938d94c0c977edd05ae07cbad7a72cc5.1321112552.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 01:37:41AM +0900, Minchan Kim wrote:
> [c1e8b0ae8, mm-change-isolate-mode-from-define-to-bitwise-type]
> made a mistake on the bitwise type.
> 

Minor nit, commit c1e8b0ae8 does not exist anywhere. I suspect you
are looking at a git tree generated from the mmotm quilt series. It
would be easier if you had said "This patch should be merged with
mm-change-isolate-mode-from-define-to-bitwise-type.patch in mmotm".

Otherwise, looks ok.

-- 
Mel Gorman
SUSE Labs

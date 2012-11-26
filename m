Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2KZNFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:05:06 -0500
Received: from science.horizon.com ([71.41.210.146]:57917 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752965Ab2KZNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:05:05 -0500
Date: 26 Nov 2012 08:05:04 -0500
Message-ID: <20121126130504.29434.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mgorman@suse.de
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
In-Reply-To: <20121126100102.GH8218@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> wrote:
> Ok, can you try this patch from Rik on top as well please? This is in
> addition to Dave Hansen's accounting fix.
> 
> ---8<---
> From: Rik van Riel <riel@redhat.com>
> Subject: mm,vmscan: only loop back if compaction would fail in all zones

Booted and running.  Judging from the patch, the expected result is
"stops hanging", as opposed to more informative diagnostics, so I'll
keep you posted.

Peraonally, I like to use "bool" for such flags where possible;
it helps document the intent of the variable better.

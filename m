Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2D3Ca3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 22:30:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52411 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2D3Ca2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 22:30:28 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-52-4f9df940a804
Message-ID: <4F9DF93F.30403@kernel.org>
Date: Mon, 30 Apr 2012 11:30:23 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Sasha Levin <levinsasha928@gmail.com>
CC: akpm@linux-foundation.org, rohit.seth@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix devision by 0 in percpu_pagelist_fraction
References: <1335623131-15728-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1335623131-15728-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 11:25 PM, Sasha Levin wrote:

> percpu_pagelist_fraction_sysctl_handler() has only considered -EINVAL as a possible error
> from proc_dointvec_minmax(). If any other error is returned, it would proceed to divide by
> zero since percpu_pagelist_fraction wasn't getting initialized at any point. For example,
> writing 0 bytes into the proc file would trigger the issue.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>


Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim

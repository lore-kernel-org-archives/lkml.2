Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965745Ab2EOCnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:43:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44070 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab2EOCnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:43:12 -0400
X-AuditID: 9c93016f-b7cecae000000e00-c4-4fb1c2bdf307
Message-ID: <4FB1C2DD.6090301@kernel.org>
Date: Tue, 15 May 2012 11:43:41 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: make validate_mm() static
References: <1337044247-4006-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1337044247-4006-1-git-send-email-yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 10:10 AM, Yuanhan Liu wrote:

> validate_mm() is just used in mmap.c only, thus make it static.
> 
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

Reveiwed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
